module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
    end

    def login
      if try_spree_current_user
        render :json => "admin" and return
      else
        #render :json => "login" and return
        redirect_to :controller => 'user_sessions', :action => 'new'
      end
    end
  end
end
