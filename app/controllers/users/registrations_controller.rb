class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    @item_ids = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->variation_id'])
    if @item_ids.empty?
      super
    else
      super do
        fulfillment = FulfillmentOption.find(params[:fulfillment])
        resource.sales.build(cart_ids: @item_ids, fulfillment_option: fulfillment)
        resource.addresses.build

        resource.save
      end
    end
  end

  def new
    @time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @afternoon = @time.middle_of_day - 1.hours...@time.end_of_day - 6.hours
    @evening = @time.middle_of_day + 6.hours...@time.end_of_day
    if @time < @time.middle_of_day - 1.hours
      @products = Product.breakfast
    else @afternoon.cover?(@time)
      @products = Product.lunch
    end
    cart_ids = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->variation_id','Id:*->price','Id:*->name','Id:*->image', '#' ])
    if cart_ids.present?
      @line_items = cart_ids
    end
    @subtotal = cart_total
    @delivery = FulfillmentOption.all
    super
  end

  def edit
    super
  end
  
  def update_card
    @user = current_user
    @user.stripe_token = params[:user][:stripe_token]
    if @user.update_attributes(account_update_params)
      redirect_to edit_user_registration_path, :notice => 'Updated card.'
    else
      flash.alert = 'Unable to update card.'
      render :edit
    end
  end
  
  def current_user_cart
    "cart#{session[:session_id]}"
  end

  def cart_total
    price = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->price'])
    total = 0
    price.map {|item| total += item.to_f }
    total
  end

  protected
  
  def update_resource(resource, account_update_params)
    resource.update_without_password(account_update_params)
  end

  def after_inactive_sign_up_path_for(resource)
    finish_signup_path(resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :stripe_token, :customer_id, :last_4_digits,:address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id, :_destroy])
  end

  def account_update_params
    params.require(:user).permit(:name, :username, :email, :stripe_token, :customer_id, :last_4_digits, :address_id, address_attributes: [:address1, :address2, :city, :state, :zip, :id])
  end
end
