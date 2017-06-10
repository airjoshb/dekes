class AddProductReferencesToLineItems < ActiveRecord::Migration
  def change
    add_reference :line_items, :product, index: true
    remove_column :line_items, :quantity, :integer
    remove_column :line_items, :unit_price, :decimal
    remove_column :line_items, :line_price, :decimal   
  end
end
