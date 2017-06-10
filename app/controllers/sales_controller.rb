class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :receipt]
  def new
    @sale = Sale.new
  end

  def create
    cart_ids_string = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->product_id'])
    token = params[:stripeToken]
    total = cart_total * 100
    begin
      
      charge = Stripe::Charge.create(
        amount:      total.to_i,
        currency:    "usd",
        source: token,
        receipt_email: params[:stripeEmail]      
      )
      @sale = Sale.create!(
        email:      params[:stripeEmail],
        total:      cart_total,
        cart_ids:   cart_ids_string.split(",").pop.map{ |s| s.to_i },      
        stripe_order_id:  charge.id
      )
      @sale.processing!
      redirect_to sale_receipt_path(sale_guid: @sale.guid)
      REDIS.del(current_user_cart)
    rescue Stripe::CardError => e
      # The card has been declined or
      # some other error has occurred
      @error = e
      render :new
    end
    @sale.send_order_email
  end
  
  
  def receipt
    respond_to do |format|
      format.html
      format.json { render json: @sale }
    end
  end

  def cart_total
    price = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->price'])
    total = 0
    price.map {|item| total += item.to_f }
    total
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    
    def set_sale
      @sale = Sale.find_by_guid(params[:guid])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:guid, :email, :stripe_order_id, :cart_ids, :total, :status, :note, :user_id, :confirmation_sent, :fulfillment_option_id)
    end


end
