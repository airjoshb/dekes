
Stripe.api_key = Rails.application.secrets.stripe_api_key
STRIPE_PUBLIC_KEY = Rails.application.secrets.stripe_public_key

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