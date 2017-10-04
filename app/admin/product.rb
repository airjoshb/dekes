ActiveAdmin.register Product do
  permit_params :name, :menu, :description, :image, :price, :category

  config.sort_order = 'created_at_desc'
  config.per_page = 10
  
  scope :all, default: true

  filter :name
  filter :created_at, label: "Created On"
  filter :menu, label: "Menu"
  filter :category, label: "Category"

  controller do
    skip_before_action :cart_items, :available_products

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column "Product" do |product|
      link_to product.name, admin_product_path(product)
    end
    column :price
    column :menu, label: "Menu"
    column :category, label: "Category"
    column "Availability" do |product|
      if product.available?
        link_to 'Mark Unavailable', mark_unavailable_admin_product_path(product), class: "button"
      else
        link_to 'Mark Available', mark_available_admin_product_path(product), class: "button"

      end
    end
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
  
  member_action :mark_available, method: :get do
    @product = Product.find(params[:id])
    @product.update_column(:available, true)
    redirect_to admin_products_path, notice: "Product Marked Available"
  end
  
  member_action :mark_unavailable, method: :get do
    @product = Product.find(params[:id])
    @product.update_column(:available, false)
    redirect_to admin_products_path, notice: "Product Marked Unavailable"
  end
  


end
