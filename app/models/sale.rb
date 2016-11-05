class Sale < ActiveRecord::Base
  belongs_to :user
  belongs_to :fulfillment_options
  has_many :line_items
end
