class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.references :user, index: true
      t.string :phone_number
      t.references :fulfillment_options, index: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
