require 'creek'
ActiveAdmin.register StockAccount do


config.paginate = true
config.per_page = 25

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage,
  :capital_sum, :capital_percentage, :register_price, :register_sum_price, :register_status, :register_at, :investment_price, :investment_sum_price,
  :investment_at, :transfered_at, :ransom_at, :meeting_sn, :change_type, :info, :visible], :on, :model

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
filter :breo_stock_num
filter :breo_stock_percentage
filter :stock_price
filter :stock_sum_price
filter :capital_sum
filter :capital_percentage
filter :investment_at
filter :ransom_at
filter :register_status, as: :select, collection: StockAccount::STATUSES
filter :meeting_sn
filter :change_type, as: :select, collection: StockAccount::TYPES
filter :transfered_at
filter :visible

scope :all, default: true
scope("有效认购A") { |static| static.active }
scope("无效认购I") { |static| static.inactive }

index do
  selectable_column
  column("#", :id) { |stock| link_to stock.id, admin_stock_account_path(stock) }
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
  column :capital_sum do |stock|
    number_to_currency(stock.capital_sum, unit: '',  precision: 1)
  end
  column :capital_percentage do |stock|
    stock.capital_percentage.to_f.round(4).to_s + " %"
  end
  column :investment_at do |stock|
    stock.investment_at.to_s
  end
  column :ransom_at do |stock|
    stock.ransom_at.nil? ? "" : stock.ransom_at.strftime("%Y-%m-%d")
  end
  column :meeting_sn
  column :transfered_at do |stock|
    stock.transfered_at.to_s
  end
  actions defaults: false do |stock|
    unless stock.visible
      item "有效", visible_admin_stock_account_path(stock), method: :put, class: "action-division"
    else
      item "无效", unvisible_admin_stock_account_path(stock), method: :put, class: "action-division"
    end
    unless stock.archived_at.nil?
      item "取消归档", unarchive_admin_stock_account_path(stock), method: :put, class: "action-division"
    else
      item "编辑", edit_admin_stock_account_path(stock), class: "action-division"
      item "归档", archive_admin_stock_account_path(stock), method: :put, class: "action-division"
    end
  end
  
end

csv do
  column(:stock_company) do |stock|
    stock.stock_company.name
  end
  column(:user) do |stock|
    stock.user.name
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
  column :capital_sum do |stock|
    number_to_currency(stock.capital_sum, unit: '',  precision: 1)
  end
  column :capital_percentage do |stock|
    stock.capital_percentage.to_f.round(4).to_s + " %"
  end
  column :register_price
  column :register_sum_price do |stock|
    number_to_currency(stock.register_sum_price, unit: '',  precision: 1)
  end
  column :register_at do |stock|
    stock.register_at.to_s
  end
  column :register_status do |stock|
    StockAccount::STATUSES_NAME[stock.register_status.to_s.to_sym]
  end
  column :investment_price
  column :investment_sum_price do |stock|
    number_to_currency(stock.investment_sum_price, unit: '',  precision: 1)
  end
  column :investment_at do |stock|
    stock.investment_at.to_s
  end
  column :ransom_at do |stock|
    stock.ransom_at.nil? ? "" : stock.ransom_at.strftime("%Y-%m-%d")
  end
  column :meeting_sn
  column :change_type do |stock|
    StockAccount::TYPES_NAME[stock.change_type.to_s.to_sym]
  end
  column :transfered_at do |stock|
    stock.transfered_at.to_s
  end
  column :info
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

member_action :archive, method: :put do
  resource.archive!
  redirect_to admin_stock_accounts_path, notice: "已归档，归档后不能编辑"
end

member_action :unarchive, method: :put do
  resource.unarchive!
  redirect_to admin_stock_accounts_path, notice: "已取消归档，当前您可以重新编辑"
end

collection_action :download, method: :get do
  send_file(Rails.root.join('public', 'import_sample.xlsx'))
end

collection_action :import, method: :get do
  render 'admin/stock_accounts/import'
end

collection_action :import_execl, method: :post do
  file = params[:file]
  unless file.blank?
    begin
      creek = Creek::Book.new file.path
      sheet = creek.sheets[1]
      errors = []
      length = 0
      types = {"股权激励" => "#{StockAccount::INSPIRE}", "股东间股权转让" => "#{StockAccount::TRANSFER}", 
      "股票股利" => "#{StockAccount::BONUS}", "私募入股" => "#{StockAccount::PRIVATE_JOIN}", 
      "离职退股" => "#{StockAccount::WORK_JUMP}", "私募退股" => "#{StockAccount::PRIVATE_OUT}"}
      sheet.rows.each_with_index do |row, index|
        next if index == 0
        length = index
        next if row.empty?
        user = User.where(name: row["A#{index + 1}"].strip).first
        if user.nil?
          errors << "用户 #{row["A#{index + 1}"]} 不存在"
          next
        end
        company = StockCompany.where(name: row["F#{index + 1}"].strip).first
        if company.nil?
          errors << "持股公司 #{row["A#{index + 1}"]} 不存在"
          next
        end
        sa = StockAccount.new(user_id: user.id, breo_stock_num: row["B#{index + 1}"].to_i, 
          breo_stock_percentage: row["C#{index + 1}"].to_f, stock_price: row["D#{index + 1}"].to_f, 
          stock_sum_price: row["E#{index + 1}"], 
          company_id: company.id,
          capital_sum: row["G#{index + 1}"],
          capital_percentage: row["H#{index + 1}"],
          register_price: row["I#{index + 1}"], 
          register_sum_price: row["J#{index + 1}"],
          register_at: row["K#{index + 1}"].to_date,
          investment_price: row["L#{index + 1}"],
          investment_sum_price: row["M#{index + 1}"], 
          investment_at: row["N#{index + 1}"].to_date,
          ransom_at: row["O#{index + 1}"].to_date,
          meeting_sn: row["P#{index + 1}"].strip,
          change_type: types[row["Q#{index + 1}"].strip], 
          transfered_at: row["R#{index + 1}"].to_date,
          info: row["S#{index + 1}"].strip,
          visible: true
        )
        if sa.valid?
          sa.save
        else
          errors << sa.errors.full_messages.to_sentence
        end
      end
      if length < 2
        flash[:warning] = "请在execl中输入有效数据后再导入"
      elsif 
        flash[:notice] = "导入数据成功"
      end
      unless errors.empty?
        flash.discard(:notice)
        flash.discard(:warning)
        flash[:warning] = errors.join(';')
      end
    rescue
      flash[:error] = "请选中有效的execl模板导入"
    end
  else
    flash[:warning] = "请选中有效的execl模板导入"
  end
  redirect_to action: :import
end

show do
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
      stock.breo_stock_percentage.to_f.round(4).to_s + " %"
    end
    row :capital_sum
    row :capital_percentage do |stock|
      stock.capital_percentage.to_f.round(4).to_s + " %"
    end
    row :register_price
    row :register_sum_price
    row :register_status do |stock|
      StockAccount::STATUSES_NAME[stock.register_status.to_s.to_sym]
    end
    row :register_at do |stock|
      stock.register_at.blank? ? "" : stock.register_at.to_s
    end
    row :investment_price
    row :investment_sum_price
    row :investment_at do |stock|
      stock.investment_at.to_s
    end
    row :transfered_at do |stock|
      stock.transfered_at.blank? ? "" : stock.transfered_at.to_s
    end
    row :ransom_at do |stock|
      stock.ransom_at.nil? ? "" : stock.ransom_at.strftime("%Y-%m-%d")
    end
    row :meeting_sn
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
    f.input :breo_stock_num, :hint => "这里填所选股东的\"增加倍轻松股份数\",必须是正整数"
    f.input :breo_stock_percentage, :hint => "可含4位小数,不大于100,不用输入%"
    f.input :capital_sum
    f.input :capital_percentage
    f.input :register_price, :hint => "1股的价格"
    f.input :register_sum_price
    f.input :register_status, :as => :select, :collection => StockAccount::STATUSES
    f.input :register_at, as: :datepicker, :hint => "\"工商系统办结状态\" 为已办结时再填写该时间"
    f.input :investment_price
    f.input :investment_sum_price
    f.input :investment_at, as: :datepicker
    f.input :transfered_at, as: :datepicker
    f.input :ransom_at, as: :datepicker, :input_html => { value: resource.ransom_at.nil? ? "" : resource.ransom_at.strftime("%Y-%m-%d") }
    f.input :meeting_sn
    f.input :change_type, :as => :select, :collection => StockAccount::TYPES
    f.input :info

    f.input :visible
  end
  
  actions if resource.new_record? || (!resource.nil? && resource.archived_at.nil?)
end

sidebar "注意事项", :only => [:new, :edit] do
    "1.认购倍轻松股份数必须是正整数<br /> 2.勾选 '认购有效' 后，最好不要再修改、删除该认购信息".html_safe
end

sidebar "导入", :only => [:new, :edit, :index] do
    link_to "批量导入股票认购信息", import_admin_stock_accounts_path
end

end