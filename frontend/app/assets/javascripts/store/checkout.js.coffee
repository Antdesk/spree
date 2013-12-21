Spree.disableSaveOnClick = ->
  ($ 'form.edit_order').submit ->
    ($ this).find(':submit, :image').attr('disabled', true).removeClass('primary').addClass 'disabled'

Spree.ready ($) ->
  Spree.Checkout = {}
  if ($ '#checkout_form_address').is('*')
    jQuery.validator.addMethod("notEqual", (value, element, param) ->
      return this.optional(element) || value != param
    , "Fyll i detta fält*")
    $(".required").focus((srcc) ->
      $(this).removeClass('defaultTextActive')
      if $(this).val() == $(this).attr('title')
        $(this).val('')
    )
    $(".required").blur(->
      if $(this).val() == ""
        $(this).addClass('defaultTextActive')
        $(this).val($(this)[0].title)

    )

    $(".required").blur()
    ($ '#checkout_form_address').validate({
      rules: {
        'order[bill_address_attributes][firstname]':{
          required: true,
          notEqual: "*First Name"
        }
        'order[bill_address_attributes][lastname]':{
          required: true,
          #notEqual: "*Last Name"
        }
        'order[bill_address_attributes][address1]':{
          required: true
        }
        'order[bill_address_attributes][city]':{
          required: true
        }
        'order[bill_address_attributes][zipcode]':{
          required: true
        }
        'order[bill_address_attributes][phone]':{
          required: true
        }
      }
    })

    alert('pov')

    getCountryId = (region) ->
      $('#' + region + 'country select').val()

    Spree.updateState = (region) ->
      countryId = getCountryId(region)
      if countryId?
        unless Spree.Checkout[countryId]?
          $.get Spree.routes.states_search, {country_id: countryId}, (data) ->
            Spree.Checkout[countryId] =
              states: data.states
              states_required: data.states_required
            Spree.fillStates(Spree.Checkout[countryId], region)
        else
          Spree.fillStates(Spree.Checkout[countryId], region)

    Spree.fillStates = (data, region) ->
      statesRequired = data.states_required
      states = data.states

      statePara = ($ '#' + region + 'state')
      stateSelect = statePara.find('select')
      stateInput = statePara.find('input')
      stateSpanRequired = statePara.find('state-required')
      if states.length > 0
        selected = parseInt stateSelect.val()
        stateSelect.html ''
        statesWithBlank = [{ name: '', id: ''}].concat(states)
        $.each statesWithBlank, (idx, state) ->
          opt = ($ document.createElement('option')).attr('value', state.id).html(state.name)
          opt.prop 'selected', true if selected is state.id
          stateSelect.append opt

        stateSelect.prop('disabled', false).show()
        stateInput.hide().prop 'disabled', true
        statePara.show()
        stateSpanRequired.show()
        stateSelect.addClass('required') if statesRequired
        stateInput.removeClass('required')
      else
        stateSelect.hide().prop 'disabled', true
        stateInput.show()
        if statesRequired
          stateSpanRequired.show()
          stateInput.addClass('required')
        else
          stateInput.val ''
          stateSpanRequired.hide()
          stateInput.removeClass('required')
        statePara.toggle(!!statesRequired)
        stateInput.prop('disabled', !statesRequired)
        stateInput.removeClass('hidden')
        stateSelect.removeClass('required')

    ($ '#bcountry select').change ->
      Spree.updateState 'b'

    ($ '#scountry select').change ->
      Spree.updateState 's'

    Spree.updateState 'b'

    order_use_billing = ($ 'input#order_use_billing')
    order_use_billing.change ->
      update_shipping_form_state order_use_billing

    update_shipping_form_state = (order_use_billing) ->
      if order_use_billing.is(':checked')
        ($ '#shipping .inner').hide()
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', true
      else
        ($ '#shipping .inner').show()
        ($ '#shipping .inner input, #shipping .inner select').prop 'disabled', false
        Spree.updateState('s')
    
    update_shipping_form_state order_use_billing

  if ($ '#checkout_form_payment').is('*')
    ($ 'input[type="radio"][name="order[payments_attributes][][payment_method_id]"]').click(->
      ($ '#payment-methods li').hide()
      ($ '#payment_method_' + @value).show() if @checked
    )

    ($ document).on('click', '#cvv_link', (event) ->
      windowName = 'cvv_info'
      windowOptions = 'left=20,top=20,width=500,height=500,toolbar=0,resizable=0,scrollbars=1'
      window.open(($ this).attr('href'), windowName, windowOptions)
      event.preventDefault()
    )

    # Activate already checked payment method if form is re-rendered
    # i.e. if user enters invalid data
    ($ 'input[type="radio"]:checked').click()
