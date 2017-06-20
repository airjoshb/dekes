class VisitorsController < ApplicationController
  def index
    @product = Product.food
  end
end
