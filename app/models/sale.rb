class Sale < ActiveRecord::Base
  belongs_to :user
  belongs_to :fulfillment_option
  has_many :line_items

  validates_uniqueness_of :guid

  accepts_nested_attributes_for :line_items, allow_destroy: true

  after_initialize  :populate_guid, :initialize_defaults
  before_save :create_line_items, :unless => Proc.new { |order| order.cart_ids.blank? }
  before_save :get_total
  before_save :charge_customer, :unless => Proc.new { |order| order.stripe_id.present? }
  default_scope {order("Created_at DESC") }


  def status_enum
    ["new", "processing", "complete", "delivered"]
  end

  serialize :cart_ids

  def confirmed?
    self.confirmation_sent == true
  end

  def deliver_order_confirmation
    SaleMailer.order_confirmation(self).deliver
    self.update_column(:confirmation_sent,true)
  end

  def initialize_defaults
    self.created_at ||= Time.now
    self.status ||= "new"
    self.total ||= 0
  end

  def create_line_items
    if new_record?
      self.cart_ids.each do |node|
        product = Product.find(node)
        line_item = LineItem.create do |li|
          li.description = product.description,
          li.name = product.name,
          li.price = product.price,
          li.guid = self.guid
        end
        self.line_items << line_item
      end
    end
  end

  def get_total
    self.total = 0
    self.line_items.each do |line_item|
      self.total += line_item.price
    end
  end

  def get_cart_line_items
    Product.find_all_by_id(self.cart_ids)
  end


  def charge_customer
    return if self.user.email.include?(ENV['ADMIN_EMAIL']) or self.user.email.include?('@gotostepone.com') or  self.user.email.include?("updatemyemail.com")
    unless self.user.customer_id.nil?
      customer = Stripe::Customer.retrieve(self.user.customer_id)
      charge = Stripe::Charge.create(
        :amount => self.total.to_i * 100, # in cents
        :currency => "usd",
        :customer => customer.id
      )
      self.stripe_id = charge.id
      self.status = "processing"
      self.email = self.user.email
    end
  end

  def initialize_user(user)
    if user
      self.user = user
      self.email = user.email
    end
  end

  private

  def populate_guid
    if new_record?
      while !valid? || self.guid.nil?
        self.guid = SecureRandom.random_number(1_000_000_000).to_s(36)
      end
    end
  end

end
