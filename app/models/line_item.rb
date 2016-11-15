class LineItem < ActiveRecord::Base
  belongs_to :sale
  validates :price, presence: true
  validates :quantity, presence: true
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0

  default_scope {order("Created_at ASC") }

  after_initialize :initialize_line_item

  def initialize_line_item
    self.quantity ||= 1
    self.status ||= "pending"
    self.created_at ||= Time.now
  end
end
