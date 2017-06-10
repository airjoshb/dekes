class LineItem < ActiveRecord::Base
  belongs_to :sale
  belongs_to :product

  default_scope {order("Created_at ASC") }

 
end
