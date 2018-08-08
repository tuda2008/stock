ActiveAdmin.register RansomStock do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:user_id, :company_id, :stock_num, :stock_price, :published_at, :info, :visible], :on, :model

actions :all, except: [:destroy]

menu priority: 4, label: "股票赎回"

filter :stock_company
filter :user
filter :stock_num
filter :stock_price
filter :visible

scope :all, default: true

scope '已赎回', :visible do |stocks|
  stocks.where(visible: true)
end

index do
  selectable_column
  column("#", :id) { |ransom_stock| link_to ransom_stock.id, admin_ransom_stock_path(ransom_stock) }
  column(:stock_company, sortable: false) do |stock|
    stock.stock_company.name
  end
  column(:user, sortable: false) do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :stock_num, sortable: true
  column :stock_price, sortable: true
  column(:published_at, sortable: true) do |stock|
    stock.published_at.to_s
  end
  column :info, sortable: false
  
  actions defaults: false do |stock|
    unless stock.visible
      item "确认赎回", visible_admin_ransom_stock_path(stock), method: :put
      item "编辑", edit_admin_ransom_stock_path(stock)
    end
  end
end

# 批量赎回
batch_action "赎回派送" do |ids|
  batch_action_collection.find(ids).each do |stock|
    stock.visible!
  end
  redirect_to collection_path, alert: "已赎回"
end

member_action :visible, method: :put do
  resource.visible!
  redirect_to admin_ransom_stocks_path, notice: "已赎回"
end

collection_action :get_companies_by_user, :method => :post do
  @user_id = params[:user_id]
  @companies = StockAccount.companies(@user_id).map{|c| {name: c.stock_company.name, id: c.company_id} }
  render :json => @companies and return
end

show do
  attributes_table do
    row :id
    row :stock_company
    row :user do |stock|
      stock.user.name + " " + stock.user.cert_id
    end
    row :stock_num
    row :stock_price
    row :published_at do |stock|
      stock.published_at.to_s
    end
    row :info
    row :visible
  end
end

form html: { multipart: true } do |f|
  @users = User.active
  @companies = @users.empty? ? [] : StockAccount.companies(@users.first.id)
  @companies = @companies.map{|c| [c.stock_company.name, c.company_id]}
  @users = @users.map{|u| [u.name + " " + u.cert_id, u.id]}

  f.semantic_errors
  
  f.inputs "赎回股票信息" do
    f.input :user, :as => :select, :collection => Hash[@users], :hint => "股东名 + 股东身份证"
    f.input :stock_company, :as => :select, :collection => Hash[@companies]
    f.input :stock_num, :hint => "这里填赎回所选股东的总股数,通常为100的倍数"
    f.input :stock_price, :hint => "这里填每股赎回单价（1股的价格）"
    f.input :published_at, as: :datepicker
    f.input :info
    f.input :visible
  end
  
  actions
end

sidebar "注意事项", :only => [:new, :edit] do
    "赎回信息最好一次性正确录入后不要修改删除".html_safe
end


end