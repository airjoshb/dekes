class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  def new
    @sale = Sale.new
  end

  def create
    @sale = Sale.new(sale_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:guid, :stripe_order_id, :cart_ids, :total, :status, :note, :user_id, :confirmation_sent, :fulfillment_option_id)
    end


end
