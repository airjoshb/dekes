class FulfillmentOptions < ActiveRecord::Base
  has_one :address
  has_many :sales
end
