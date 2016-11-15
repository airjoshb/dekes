class Product < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name


  extend FriendlyId
  friendly_id :name, use: :slugged
  
  mount_uploader :image, ImageUploader
  
  enum menu: [:breakfast, :lunch, :dinner]
  
  enum category: [:food, :snack, :drink]
  
  scope :morning, -> { where(menu: :breakfast) }
  scope :afternoon, -> { where(menu: :lunch) }
  
end
