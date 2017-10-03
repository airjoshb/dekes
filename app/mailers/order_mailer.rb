class OrderMailer < ActionMailer::Base
  default :from => "dekesmkt@gmail.com"


  def order_confirmation(sale)
    @sale = sale
    mail(:to => "dekesmkt@gmail.com", :subject => "You've got a web order")
  end


end