ActiveAdmin.register StockCompany do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

permit_params :list, :of, [:name, :description], :on, :model

actions :all, except: [:destroy]

menu priority: 2, label: "公司管理"

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
filter :name
filter :description

scope :all, default: true

scope '正常运营', :visible do |companies|
  companies.where(visible: true)
end

index do
  @sum = StockCompany.sum_stock_price
  selectable_column
  column("#", :id) { |company| link_to company.id, admin_stock_company_path(company) }

  column(:name, sortable: false) do |company|
    company.name
  end
  column "工商登记入股金额合计" do |company|
    @sum["#{company.id}"][:sum_register_sum_price] if @sum["#{company.id}"]
  end
  column "增加所持公司工商登记出资额合计" do |company|
    @sum["#{company.id}"][:sum_capital_sum] if @sum["#{company.id}"]
  end
  column "平均股价" do |company|
    if @sum["#{company.id}"]
      @sum["#{company.id}"][:sum_capital_sum] > 0 ? (@sum["#{company.id}"][:sum_register_sum_price]/@sum["#{company.id}"][:sum_capital_sum]).to_f.round(2) : ""
    end
  end
  #column :legal_representative, sortable: false
  #column :stockholders_num, sortable: false
  #column :holders_stock_num, sortable: false
  #column :holders_buy_sum_price, sortable: false
  #column :ransom_stock_num, sortable: false
  #column :ransom_sum_price, sortable: false
  #column :holders_stock_sum_price, sortable: false
  #column :stock_price, sortable: false
  #column :estimate_market_price, sortable: false
  
  column "公司运营情况" do |company|
    company.visible ? "正常" : "不正常"
  end
  
  actions defaults: false do |company|
    if company.visible
      item "不正常", block_admin_stock_company_path(company), method: :put
    else
      item "正常", unblock_admin_stock_company_path(company), method: :put
    end
    item "编辑", edit_admin_stock_company_path(company)
  end
end

# 批量禁用账号
batch_action "不正常" do |ids|
  batch_action_collection.find(ids).each do |company|
    company.block!
  end
  redirect_to collection_path, alert: "已设为不正常"
end

# 批量启用账号
batch_action "正常" do |ids|
  batch_action_collection.find(ids).each do |company|
    company.unblock!
  end
  redirect_to collection_path, alert: "已设为正常"
end

member_action :block, method: :put do
  resource.block!
  redirect_to admin_stock_companies_path, notice: "已设为不正常"
end

member_action :unblock, method: :put do
  resource.unblock!
  redirect_to admin_stock_companies_path, notice: "已设为正常"
end

show do
  attributes_table do
    row :id
    row :name
    row :description do |company|
      company.description.blank? ? '' : raw("<div style='text-align:left'>#{company.description}</div>")
    end
    #row :legal_representative
    #row :stockholders_num
    #row :holders_stock_num
    #row :holders_buy_sum_price
    #row :ransom_stock_num
    #row :ransom_sum_price
    #row :holders_stock_sum_price
    #row :stock_price
    #row :estimate_market_price
    row :visible do |company|
      company.visible ? "正常" : "不正常"
    end
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs "公司信息" do
    f.input :name, :hint => "未指定公司的名字暂用\"内部管理\"代替"
    f.input :description
  end
  
  actions
end

sidebar "使用须知", :only => [:index] do
    "第一步.在 '股东管理' -> '新建股东'<br /> 
     第二步.在 '公司管理' -> '新建公司'<br />
     第三步.在 '股票认购' -> '新建股票认购'<br />
     第四步.在 '股票赎回' -> '新建股票赎回'<br />".html_safe
end

end
