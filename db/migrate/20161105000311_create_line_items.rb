class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :line_price
      t.references :sale, index: true

      t.timestamps
    end
  end
end
