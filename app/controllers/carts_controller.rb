class CartsController < ApplicationController

  def show
    @subtotal = cart_total
    respond_to do |format|
      format.html #
      format.js
    end
  end

  def add
    incr_id = REDIS.incrby(:id,  1)
    @id = "Id:#{incr_id}"
    line_item = REDIS.hmset(@id,  :product_id, params[:product_id], :price, params[:price], :name, params[:name], :image, params[:image])
    REDIS.sadd current_user_cart, incr_id
    render :js => "window.location = '#{cart_path}'"
  end

  def remove
    REDIS.srem current_user_cart, params[:item_id]
    render :js => "window.location = '#{cart_path}'"

  end

  def cart_total
    price = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->price'])
    total = 0
    price.map {|item| total += item.to_f }
    total
  end
  
  def checkout
    cart_ids = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->variation_id','Id:*->price','Id:*->name','Id:*->image', '#' ])
    if cart_ids.present?
      @line_items = cart_ids
    end
    @subtotal = cart_total
  end

  private

  def current_user_cart
    "cart#{session[:session_id]}"
  end

end
