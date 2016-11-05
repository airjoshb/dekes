class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :menu
      t.text :description
      t.string :image
      t.decimal :price

      t.timestamps
    end
  end
end
