class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :fulfillment_options
  validates_formatting_of :zip, using: :us_zip
  validates_formatting_of :phone_number, using: :us_phone
  
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.full_address.present? and obj.address_changed? }

  def address_changed?
    attrs = %w(address1 city state zip)
    attrs.any?{|a| send "#{a}_changed?"}
  end

  def full_address
    "#{address1}, #{zip}, #{city}, #{state}"
  end
end
