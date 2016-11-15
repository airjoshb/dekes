if(Rails.env == 'development')
  Stripe.api_key = ENV["STRIPE_TEST_API_KEY"]
  STRIPE_PUBLIC_KEY = ENV["STRIPE_TEST_PUBLIC_KEY"]
elsif(Rails.env == 'production')
  Stripe.api_key = ENV["STRIPE_API_KEY"]
  STRIPE_PUBLIC_KEY = ENV["STRIPE_PUBLIC_KEY"]
end
StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.deleted' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    user.expire
  end

  events.subscribe 'customer.subscription.updated' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    if event.data.object.status == "past_due"
      user.renewal_fail
    elsif event.data.object.status == "unpaid"
      user.unpaid
    elsif event.data.object.status == "active"
      user.renewal
    end
  end

end