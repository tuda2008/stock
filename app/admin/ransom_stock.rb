ActiveAdmin.register RansomStock do

config.paginate = true
config.per_page = 25

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage, 
  :capital_sum, :capital_percentage, :register_price, :register_sum_price, :tax, :published_at, :tax_payed_at, :info, :visible], :on, :model

actions :all, except: [:destroy]

menu priority: 3, label: "股票赎回"

filter :stock_company
filter :user
filter :breo_stock_num
filter :breo_stock_percentage
filter :stock_price
filter :stock_sum_price
filter :published_at
filter :visible

scope :all, default: true
scope("已赎回S") { |ransom_stock| ransom_stock.active }
scope("待赎回W") { |ransom_stock| ransom_stock.inactive }

index do
  selectable_column
  column("#", :id) { |ransom_stock| link_to ransom_stock.id, admin_ransom_stock_path(ransom_stock) }
  column(:company_id) do |stock|
    stock.stock_company.name
  end
  column(:user_id) do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num do |stock|
    number_to_currency(stock.breo_stock_num, unit: '',  precision: 0)
  end
  column :breo_stock_percentage do |stock|
    stock.breo_stock_percentage.to_f.round(4).to_s + " %"
  end
  column :stock_price
  column :stock_sum_price do |stock|
    number_to_currency(stock.stock_sum_price, unit: '',  precision: 1)
  end
  column :published_at do |stock|
    stock.published_at.to_s
  end
  column "已/待赎回" do |stock|
    stock.visible ? "已赎回" : "待赎回"
  end
  
  actions defaults: false do |stock|
    unless stock.visible
      item "确认赎回", visible_admin_ransom_stock_path(stock), method: :put, class: "action-division"
    end
    unless stock.archived_at.nil?
      item "取消归档", unarchive_admin_ransom_stock_path(stock), method: :put, class: "action-division"
    else
      item "编辑", edit_admin_ransom_stock_path(stock), class: "action-division"
      item "归档", archive_admin_ransom_stock_path(stock), method: :put, class: "action-division"
    end
  end
end

csv do
  column(:stock_company) do |stock|
    stock.stock_company.name
  end
  column(:user) do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num do |stock|
    number_to_currency(stock.breo_stock_num, unit: '',  precision: 0)
  end
  column :breo_stock_percentage do |stock|
    stock.breo_stock_percentage.to_f.round(4).to_s + " %"
  end
  column :capital_sum do |stock|
    number_to_currency(stock.capital_sum, unit: '',  precision: 1)
  end
  column :capital_percentage do |stock|
    stock.capital_percentage.to_f.round(4).to_s + " %"
  end
  column :stock_price
  column :stock_sum_price do |stock|
    number_to_currency(stock.stock_sum_price, unit: '',  precision: 1)
  end
  column :register_price
  column :register_sum_price do |stock|
    number_to_currency(stock.register_sum_price, unit: '',  precision: 1)
  end
  column :tax do |stock|
    number_to_currency(stock.tax, unit: '',  precision: 1)
  end
  column :sum_price_after_tax do |stock|
    number_to_currency(stock.sum_price_after_tax, unit: '',  precision: 1)
  end
  column :published_at do |stock|
    stock.published_at.to_s
  end
  column :tax_payed_at do |stock|
    stock.tax_payed_at.to_s
  end
  column :info
  column "已/待赎回" do |stock|
    stock.visible ? "已赎回" : "待赎回"
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

member_action :archive, method: :put do
  resource.archive!
  redirect_to admin_ransom_stocks_path, notice: "已归档，归档后不能编辑"
end

member_action :unarchive, method: :put do
  resource.unarchive!
  redirect_to admin_ransom_stocks_path, notice: "已取消归档，当前您可以重新编辑"
end

collection_action :get_companies_by_user, :method => :post do
  @user_id = params[:user_id]
  @companies = StockAccount.companies(@user_id).uniq.map{|c| {name: c.stock_company.name, id: c.company_id} }
  render :json => @companies and return
end

show do
  attributes_table do
    row :id
    row :stock_company
    row :user do |stock|
      stock.user.name + " " + stock.user.cert_id
    end
    row :breo_stock_num
    row :breo_stock_percentage
    row :capital_sum
    row :capital_percentage
    row :stock_price
    row :stock_sum_price
    row :register_price
    row :register_sum_price
    row :tax
    row :sum_price_after_tax
    row :published_at do |stock|
      stock.published_at.to_s
    end
    row :tax_payed_at do |stock|
      stock.tax_payed_at.to_s
    end
    row :info
    row :visible
  end
end

form html: { multipart: true } do |f|
  @users = User.active
  if resource.user_id.present?
    @companies = StockAccount.companies(resource.user_id)
  else
    @companies = @users.empty? ? [] : StockAccount.companies(@users.first.id)
  end
  @companies = @companies.map{|c| [c.stock_company.name, c.company_id]}
  @users = @users.map{|u| [u.name + " " + u.cert_id, u.id]}

  f.semantic_errors
  
  f.inputs "赎回股票信息" do
    f.input :user_id, :as => :select, :collection => Hash[@users], :hint => "股东名 + 股东身份证"
    f.input :company_id, :as => :select, :collection => Hash[@companies]
    f.input :breo_stock_num, :hint => "不能大于买入倍轻松股份数"
    f.input :breo_stock_percentage, :hint => "不能大于买入倍轻松股份占比"
    f.input :capital_sum
    f.input :capital_percentage
    f.input :stock_price, :hint => "1股的价格"
    f.input :stock_sum_price
    f.input :register_price, :hint => "1股的价格"
    f.input :register_sum_price
    f.input :tax
    f.input :published_at, as: :datepicker
    f.input :tax_payed_at, as: :datepicker
    f.input :info
    f.input :visible
  end
  
  actions if resource.new_record? || (!resource.nil? && resource.archived_at.nil?)
end

sidebar "注意事项", :only => [:new, :edit] do
    "赎回信息最好一次性正确录入后不要修改删除".html_safe
end


end