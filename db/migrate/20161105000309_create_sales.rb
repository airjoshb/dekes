class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :guid
      t.decimal :total
      t.integer :status
      t.boolean :confirmation_sent
      t.text :note
      t.string :stripe_order_id
      t.references :user, index: true
      t.references :fulfillment_options, index: true

      t.timestamps
    end
  end
end
