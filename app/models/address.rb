class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :fulfillment_options
  validates_formatting_of :zip, using: :us_zip
end
