class CreateFulfillmentOptions < ActiveRecord::Migration
  def change
    create_table :fulfillment_options do |t|
      t.string :name

      t.timestamps
    end
  end
end
