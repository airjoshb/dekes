class Product < ActiveRecord::Base
  has_many :line_items
  
  validates_presence_of :name
  validates_uniqueness_of :name


  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  mount_uploader :image, ImageUploader
  
  enum menu: [:breakfast, :lunch, :dinner]
  
  enum category: [:food, :snack, :drink]
  
  scope :morning, -> { where(menu: :breakfast) }
  scope :afternoon, -> { where(menu: :lunch) }
  scope :food, -> { where(category: :food)}
  
end
