module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      url = request.original_url
      if url.include? 'lit-plains' or url.include? 'http://lycolife'
        redirect_to 'http://www.lycolife.se/'
      end
    end

    def login
      if try_spree_current_user
        #render :json => "admin" and return
        redirect_to '/admin/orders#index' and return
      else
        #render :json => "login" and return
        #redirect_to :controller => 'user_sessions', :action => 'new'
        redirect_to '/login' and return
      end
    end
  end
end
