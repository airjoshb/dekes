class AddCartIdsToSales < ActiveRecord::Migration
  def change
    add_column :sales, :cart_ids, :text
  end
end
