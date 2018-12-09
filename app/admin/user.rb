ActiveAdmin.register User do

config.paginate = true
config.per_page = 25


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:name, :mobile, :email, :bank_name, :card, :cert_id, :cert_address, :department, :user_cate, :user_type], :on, :model

actions :all, except: [:destroy]

menu priority: 1, label: "股东管理"

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
filter :mobile
filter :card
filter :cert_id
filter :department
filter :user_cate, :as => :select, :collection => User::CATES
filter :user_type, :as => :select, :collection => User::TYPE


scope :all, default: true
scope("正常股东A") { |user| user.active }
scope("冻结股东I") { |user| user.inactive }

index do
  selectable_column
  column("#", :id) { |user| link_to user.id, admin_user_path(user) }
  column :name do |user|
    link_to(user.name, admin_account_statics_path(q: {user_id_eq: user.id}), class: "account_static")
  end
  column :mobile, sortable: false
  column :card
  column :cert_id
  column :department
  column :user_cate do |user|
    User::CATES_NAME[user.user_cate.to_s.to_sym]
  end
  column :user_type do |user|
    User::TYPE_NAME[user.user_type.to_s.to_sym]
  end
  column "账号是否正常" do |user|
    user.locked_at.blank? ? "正常" : "已冻结于 " + user.locked_at.strftime("%Y-%m-%d %H:%M:%S")
  end
  actions defaults: false do |user|
    if user.locked_at.nil?
      item "冻结", lock_admin_user_path(user), method: :put, class: "action-division inactive"
    else
      item "激活", unlock_admin_user_path(user), method: :put, class: "action-division active"
    end

    item "编辑", edit_admin_user_path(user), class: "action-division"
  end
end

csv do
  column :name
  column :department
  column :cert_id
  column :cert_address
  column :bank_name
  column :card
  column :mobile
  column :email
  column :user_cate do |user|
    User::CATES_NAME[user.user_cate.to_s.to_sym]
  end
  column :user_type do |user|
    User::TYPE_NAME[user.user_type.to_s.to_sym]
  end
  column "账号是否正常" do |user|
    user.locked_at.blank? ? "正常" : "已冻结于 " + user.locked_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end

member_action :lock, method: :put do
  if AccountStatic.by_user(resource.id).has_stock.any?
    flash[:warning] = "该股东还有正常持股，不能冻结"
    redirect_to admin_users_path
  else
    resource.lock!
    redirect_to admin_users_path, notice: "已冻结"
  end
end

member_action :unlock, method: :put do
  resource.unlock!
  redirect_to admin_users_path, notice: "已激活"
end

collection_action :download, method: :get do
  send_file(Rails.root.join('public', 'import_sample.xlsx'))
end

collection_action :import, method: :get do
  render 'admin/users/import'
end

collection_action :import_execl, method: :post do
  file = params[:file]
  unless file.blank?
    begin
      creek = Creek::Book.new file.path
      sheet = creek.sheets[0]
      length = 0
      cates = {"员工" => "1", "外部" => "2"}
      types = {"自然人" => "1", "法人股东" => "2", "外资" => "3"}
      errors = []
      errors = []
      sheet.rows.each_with_index do |row, index|
        next if index == 0
        length = index
        next if row.empty?
        user = User.new(name: row["A#{index + 1}"].nil? ? "" : row["A#{index + 1}"].strip, 
          department: row["B#{index + 1}"].nil? ? "" : row["B#{index + 1}"].strip,
          cert_id: row["C#{index + 1}"].nil? ? "" : row["C#{index + 1}"].strip, 
          cert_address: row["D#{index + 1}"].nil? ? "" : row["D#{index + 1}"].strip,
          bank_name: row["E#{index + 1}"].nil? ? "" : row["E#{index + 1}"].strip, 
          card: row["F#{index + 1}"].nil? ? "" : row["F#{index + 1}"],
          mobile: row["G#{index + 1}"].nil? ? "" : row["G#{index + 1}"].strip,
          email: row["H#{index + 1}"].nil? ? "" : row["H#{index + 1}"],
          user_cate: row["I#{index + 1}"].nil? ? "" : cates[row["I#{index + 1}"].strip],
          user_type: row["J#{index + 1}"].nil? ? "" : types[row["J#{index + 1}"].strip])
        if user.valid?
          user.save
        else
          errors << user.errors.full_messages.to_sentence
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
    row :name
    row :mobile

    row :cert_id
    row :cert_address

    row :department
    row :user_cate do |user|
      User::CATES_NAME[user.user_cate.to_s.to_sym]
    end
    row :user_type do |user|
      User::TYPE_NAME[user.user_type.to_s.to_sym]
    end

    row :email
    row :bank_name
    row :card

    row :locked_at do |user|
      user.locked_at.blank? ? "正常用户，未冻结" : "已冻结于 " + user.locked_at.to_s
    end
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs "股东信息" do
    f.input :name, :hint => "重名则加上部门，如\"财务王五\""
    f.input :mobile

    f.input :cert_id, :required => true
    f.input :cert_address

    f.input :department
    f.input :user_cate, :as => :select, :collection => User::CATES
    f.input :user_type, :as => :select, :collection => User::TYPE

    f.input :email
    f.input :bank_name
    f.input :card

    #f.input :password
    #f.input :password_confirmation
  end
  
  actions
end

sidebar "导入", :only => [:new, :edit, :index] do
    link_to "批量导入股东信息", import_admin_users_path
end

end