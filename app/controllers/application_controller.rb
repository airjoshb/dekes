class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_action :cart_items, :available_products
  helper_method :open_for_business
   
  def cart_items
    @cart_items = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->price'])
  end
  
  def available_products
    cart_products = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->product_id','Id:*->price','Id:*->name','Id:*->image', '#' ])
    @cart_line_items = cart_products
    
    @time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @afternoon = @time.middle_of_day - 1.hours...@time.end_of_day - 6.hours
    @evening = @time.middle_of_day + 6.hours...@time.end_of_day
    if @time < @time.middle_of_day - 1.hours
      @products = Product.breakfast.available
    else @afternoon.cover?(@time)
      @products = Product.lunch.available
    end
    @snacks = Product.snack
    @drinks = Product.drink
  end
  
  def open_for_business
    t1 = Time.zone.parse("9am")
    t2 = Time.zone.parse("4pm")
    Time.zone.now.between?(t1, t2)
  end

  
  protected

  #->Prelang (user_login:devise)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:username, :email, :password, :password_confirmation, :remember_me, :address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id])
    end
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :password, :password_confirmation, :remember_me, :address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :remember_me,:address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id]])
  end

 

  private


  def current_user_cart
    "cart#{session[:session_id]}"
  end
  
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
