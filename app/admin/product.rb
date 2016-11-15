ActiveAdmin.register Product do
  permit_params :name, :menu, :description, :image, :price, :category

  scope :all

  filter :name
  filter :created_at, label: "Created On"
  filter :menu, label: "Menu"
  filter :category, label: "Category"


  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column "Product" do |product|
      link_to product.name, admin_product_path(product)
    end
    column :created_at, label: "Created"
    column :price
    column :menu, label: "Menu"
    column :category, label: "Category"
    actions
  end



  form do |f|
    f.inputs "Product Details" do
      f.input :image
      f.input :name
      f.input :description
      f.input :price
      f.input :menu, as: :select, collection: Product.menus.keys.to_a
      f.input :category, as: :select, collection: Product.categories.keys.to_a
    end
    f.actions
  end


end
