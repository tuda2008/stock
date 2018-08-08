ActiveAdmin.register StockAccount do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:user_id, :company_id, :stock_sum, :stock_price, :published_at, :visible], :on, :model

actions :all, except: [:destroy]

menu priority: 2, label: "股票认购"

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
# member_action :lock, method: :put do
#   resource.lock!
#   redirect_to admin_users_path, notice: resource.verified ? 'Locked!' : 'Cancel Locked!'
# end
filter :stock_company
filter :user
filter :stock_sum
filter :stock_price
filter :published_at
#filter :level
filter :visible

scope :all, default: true

scope '有效认购', :visible do |users|
  users.where(visible: true)
end

index do
  selectable_column
  column("#", :id) { |stock| link_to stock.id, admin_stock_account_path(stock) }

  column(:stock_company, sortable: false) do |stock|
    stock.stock_company.name
  end
  column(:user, sortable: false) do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :stock_sum, sortable: false
  column :stock_price, sortable: false
  #column :level, sortable: true
  column(:published_at, sortable: true) do |stock|
    stock.published_at.to_s
  end
  column :visible, sortable: true
  
  actions defaults: false do |stock|
    unless stock.visible
      item "有效", visible_admin_stock_account_path(stock), method: :put
    else
      item "无效", unvisible_admin_stock_account_path(stock), method: :put
    end
    item "编辑", edit_admin_stock_account_path(stock)
  end
  
end

batch_action "设为有效" do |ids|
  batch_action_collection.find(ids).each do |user|
    user.visible!
  end
  redirect_to collection_path, alert: "已设为有效"
end

batch_action "设为无效" do |ids|
  batch_action_collection.find(ids).each do |user|
    user.unvisible!
  end
  redirect_to collection_path, alert: "已设为无效"
end

member_action :visible, method: :put do
  resource.visible!
  redirect_to admin_stock_accounts_path, notice: "已设为有效"
end

member_action :unvisible, method: :put do
  resource.unvisible!
  redirect_to admin_stock_accounts_path, notice: "已设为无效"
end

show do
  attributes_table do
    row :id
    row :stock_company
    row :user do |stock|
      stock.user.name + " " + stock.user.cert_id
    end
    row :stock_sum
    row :stock_price
    #row :level
    row :published_at do |stock|
      stock.published_at.to_s
    end
    
    row :visible do |stock|
      stock.visible ? "有效" : "无效"
    end
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs "认购信息" do
    f.input :user, :as => :select, :collection => Hash[User.active.map{|u| [u.name + " " + u.cert_id,u.id]}], :hint => "股东名 + 股东身份证"
    f.input :stock_company
    f.input :stock_sum, :hint => "这里填所选股东的认购总股数,通常为100的倍数"
    f.input :stock_price, :hint => "这里填所选股东的每股认购单价（1股的价格）"
    #f.input :level, :hint => "这里填您的股东级数，若2级股东填2"
    f.input :published_at, as: :datepicker
    f.input :visible
  end
  
  actions
end

sidebar "注意事项", :only => [:new, :edit] do
    "1.认购股数必须是100的整数倍<br /> 2.勾选 '认购有效' 后，最好不要再修改、删除该认购信息".html_safe
end

end