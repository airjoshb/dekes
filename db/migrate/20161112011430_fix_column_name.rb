class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :sales, :fulfillment_options_id, :fulfillment_option_id
    rename_column :addresses, :fulfillment_options_id, :fulfillment_option_id
  end
end
