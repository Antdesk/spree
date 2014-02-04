$ ->
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')
    ($ '#main-image').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'

    ($ '#main-image img').on 'click', (event) ->
      hr = ($ event.currentTarget).attr('src')
      hr = hr.replace('product/', 'original/')
      $.fancybox.open([
        {
          href: hr
        }
      ], {
        closeClick : true
      })


    thumbnails.find('a').on 'click', (event) ->
      hr = ($ event.currentTarget).attr('href')
      hr = hr.replace('product/', 'original/')
      $.fancybox.open([
        {
          href: hr
        }
      ], {
        closeClick : true
      })

      ($ '#main-image').data 'selectedThumb', ($ event.currentTarget).attr('href')
      ($ '#main-image').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      ($ this).mouseout ->
        alert('mouse out')
        thumbnails.find('li').removeClass 'selected'
        ($ event.currentTarget).parent('li').addClass 'selected'
      false

    thumbnails.find('li').on 'mouseenter', (event) ->
      alert('mouse enter')
      ($ '#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

    ###thumbnails.find('li').on 'mouseleave', (event) ->
      alert('mouse leave')
      ($ '#main-image img').attr 'src', ($ '#main-image').data('selectedThumb')###

  Spree.showVariantImages = (variantId) ->
    ($ 'li.vtmb').hide()
    ($ 'li.tmb-' + variantId).show()
    currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = ($ ($ '#product-images ul.thumbnails li:visible.vtmb').eq(0))
      thumb = ($ ($ '#product-images ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      ($ '#product-images ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      ($ '#main-image img').attr 'src', newImg
      ($ '#main-image').data 'selectedThumb', newImg
      ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    ($ '.price.selling').text(variantPrice) if variantPrice
  radios = ($ '#product-variants input[type="radio"]')

  if radios.length > 0
    Spree.showVariantImages ($ '#product-variants input[type="radio"]').eq(0).attr('value')
    Spree.updateVariantPrice radios.first()

  Spree.addImageHandlers()

  radios.click (event) ->
    Spree.showVariantImages @value
    Spree.updateVariantPrice ($ this)
