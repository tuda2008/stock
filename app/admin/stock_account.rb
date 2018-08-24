ActiveAdmin.register StockAccount do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage,
  :capital_sum, :register_price, :register_sum_price, :register_status, :register_at, :investment_sum_price,
  :investment_at, :transfered_at, :change_type, :info, :visible], :on, :model

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
filter :stock_price
filter :investment_at
filter :register_status, :as => :select, :collection => StockAccount::STATUSES
filter :change_type, :as => :select, :collection => StockAccount::TYPES
filter :info
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
  column :stock_price, sortable: false
  column :stock_sum_price, sortable: false
  column :breo_stock_percentage do |stock|
    stock.breo_stock_percentage.to_s + " %"
  end
  column(:investment_at, sortable: true) do |stock|
    stock.investment_at.to_s
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

csv do
  column(:stock_company) do |stock|
    stock.stock_company.name
  end
  column(:user) do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :stock_price
  column :stock_sum_price
  column :breo_stock_percentage do |stock|
    stock.breo_stock_percentage.to_s + " %"
  end
  column(:investment_at) do |stock|
    stock.investment_at.to_s
  end
  column :visible
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
  @sum = StockCompany.sum_stock_price
  attributes_table do
    row :id
    row :stock_company
    row :user do |stock|
      stock.user.name + " " + stock.user.cert_id
    end
    row :stock_price
    row :stock_sum_price
    row :breo_stock_num
    row :breo_stock_percentage do |stock|
      stock.breo_stock_percentage.to_s + " %"
    end
    row :capital_sum
    row :capital_percentage do |stock|
      if @sum[:sum_capital_sum] > 0 
        (stock.capital_sum.to_f*100/@sum[:sum_capital_sum]).round(5).to_s + " %"
      end
    end
    row :register_price
    row :register_sum_price
    row :register_status do |stock|
      StockAccount::STATUSES_NAME[stock.register_status.to_s.to_sym]
    end
    row :register_at do |stock|
      stock.register_at.blank? ? "" : stock.register_at.to_s
    end
    row :investment_sum_price
    row :investment_at do |stock|
      stock.investment_at.to_s
    end
    row :transfered_at do |stock|
      stock.transfered_at.blank? ? "" : stock.transfered_at.to_s
    end
    row :change_type do |stock|
      StockAccount::TYPES_NAME[stock.change_type.to_s.to_sym]
    end
    row :info
    
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
    f.input :stock_price, :hint => "1股的价格"
    f.input :stock_sum_price
    f.input :breo_stock_num, :hint => "这里填所选股东的\"增加倍轻松股份数\",通常为100的倍数"
    f.input :breo_stock_percentage, :hint => "可含4位小数,不大于100"
    f.input :capital_sum
    f.input :register_price, :hint => "1股的价格"
    f.input :register_sum_price
    f.input :register_status, :as => :select, :collection => StockAccount::STATUSES
    f.input :register_at, as: :datepicker, :hint => "\"工商系统办结状态\" 为已办结时再填写该时间"
    f.input :investment_sum_price
    f.input :investment_at, as: :datepicker
    f.input :transfered_at, as: :datepicker
    f.input :change_type, :as => :select, :collection => StockAccount::TYPES
    f.input :info

    f.input :visible
  end
  
  actions
end

sidebar "注意事项", :only => [:new, :edit] do
    "1.认购倍轻松股份数必须是100的整数倍<br /> 2.勾选 '认购有效' 后，最好不要再修改、删除该认购信息".html_safe
end

end