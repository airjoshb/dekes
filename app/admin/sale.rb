ActiveAdmin.register Sale do
  permit_params :guid, :total, :status, :confirmation_sent, :note, :stripe_order_id, :id, :email

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  
  index do
    selectable_column
    column "Sale" do |sale|
      link_to sale.guid, admin_sale_path(sale)
    end
    column :created_at, label: "Created"
    column :total
    column :status
    column :confirmation_sent
    column :stripe_order_id
    column :email
    column "line items" do |li|
      li.line_items.map{|p| p.product.name}.join(',')
    end
    actions
  end
  
  member_action :complete_order, method: :get do
    @sale = Sale.find(params[:id])
    @sale.deliver_order_confirmation
    @sale.complete!
    redirect_to admin_sales_path, notice: "Customer notified for pickup"
  end
  
  
  action_item only: :show do
    link_to 'Complete', complete_order_admin_sale_path(sale)
  end




end
