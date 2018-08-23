ActiveAdmin.register StockSplit do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:company_id, :stock_transfer, :stock_send, :stock_bonus, :enabled, :published_at, :info], :on, :model

actions :all, except: [:destroy]

#menu priority: 6, label: "分红派股"
menu false

filter :stock_company
filter :stock_transfer
filter :stock_send
filter :stock_bonus
filter :published_at
filter :enabled

scope :all, default: true

scope '已分派', :enabled do |stocks|
  stocks.where(enabled: true)
end

index do
  selectable_column
  column("#", :id) { |stock_split| link_to stock_split.id, admin_stock_split_path(stock_split) }
  column :stock_transfer, sortable: true
  column :stock_send, sortable: true
  column :stock_bonus, sortable: true
  column(:published_at, sortable: true) do |stock|
    stock.published_at.to_s
  end
  column "是否分派" do |stock|
    stock.enabled ? "已分派" : "未分派"
  end
  column :info, sortable: false
  
  actions defaults: false do |stock|
    unless stock.enabled
      item "确认派送", enable_admin_stock_split_path(stock), method: :put
      item "编辑", edit_admin_stock_split_path(stock)
    end
  end
  
end

# 批量分红派股
batch_action "派送" do |ids|
  batch_action_collection.find(ids).each do |stock|
    stock.enable!
  end
  redirect_to collection_path, alert: "已分派"
end

member_action :enable, method: :put do
  resource.enable!
  redirect_to admin_stock_splits_path, notice: "已分派"
end

show do
  attributes_table do
    row :id
    row :stock_transfer
    row :stock_send
    row :stock_bonus
    row :published_at do |stock|
      stock.published_at.to_s
    end
    row :enabled
    row :info
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs "分红派股信息" do
    f.input :stock_company
    f.input :stock_transfer, :hint => "这里填您的转股信息，若10转5，只填写5，无填0"
    f.input :stock_send, :hint => "这里填您的送股信息，若10送15，只填写15，无填0"
    f.input :stock_bonus, :hint => "这里填您的派现信息，若10派8，只填写8，无填0"
    f.input :published_at, as: :datepicker
    f.input :enabled
    f.input :info
  end
  
  actions
end

sidebar "注意事项", :only => [:new, :edit] do
    "1.转股、送股、分红三者至少必须填一项<br /> 2.勾选 '确认派送' 后，最好不要再修改、删除该派送信息<br />
     3.确认派送后，在派股日期前有认购所选公司的股东都将获得派股分红".html_safe
end


end
