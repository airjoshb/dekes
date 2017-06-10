class OrderMailer < ActionMailer::Base
  default :from => "dekesmkt@gmail.com"


  def order_confirmation(sale)
    @sale = sale
    mail(:to => @sale.email, :subject => "You've got a web order")
  end


end