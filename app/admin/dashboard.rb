ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
  

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Active Sales" do
          table_for Sale.processing.each do |sale|
            column :created_at
            column (:guid) {|g| link_to(g.guid, admin_sale_path(g)) }
            column :total
            column :status             
            column :email
            column :stripe_order_id
            column "line items" do |li|
              li.line_items.map{|p| p.product.name}
            end
          end
        end
      end
    end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
