class SaleMailer < ActionMailer::Base
  default :from => "dekesmkt@gmail.com"


  def order_confirmation(sale)
    @sale = sale
    mail(:to => @sale.email, :subject => "Your Deke's Market sandwich is ready")
  end


end