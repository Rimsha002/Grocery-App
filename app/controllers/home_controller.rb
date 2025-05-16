class HomeController < ApplicationController
  def index
    @featured_products = Product.featured.limit(4)
  end
end 