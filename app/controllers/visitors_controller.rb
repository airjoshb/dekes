class VisitorsController < ApplicationController
  def index
    @time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @afternoon = @time.middle_of_day - 1.hours...@time.end_of_day - 6.hours
    @evening = @time.middle_of_day + 6.hours...@time.end_of_day
    if @time < @time.middle_of_day - 1.hours
      @products = Product.breakfast
    else @afternoon.cover?(@time)
      @products = Product.lunch
    end
  end
end
