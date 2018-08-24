ActiveAdmin.register User do

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

scope '正常股东', :unlocked do |users|
  users.where("locked_at is null")
end

index do
  selectable_column
  column("#", :id) { |user| link_to user.id, admin_user_path(user) }
  column :name
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
    user.locked_at.blank? ? "正常" : "已冻结于 " + user.locked_at.to_s
  end
  
  
  actions defaults: false do |user|
    item "    编辑", edit_admin_user_path(user)
  end
  
end

csv do
  column :name
  column :mobile, sortable: false
  column :card
  column :cert_id
  column :department
  column :user_cate do |user|
    User::CATES_NAME[user.user_cate.to_s.to_sym]
  end
end

show do
  attributes_table do
    row :id
    row :name
    row :mobile
    row :email

    row :bank_name
    row :card
    row :cert_id
    row :cert_address

    row :department
    row :user_cate do |user|
      User::CATES_NAME[user.user_cate.to_s.to_sym]
    end
    row :user_type do |user|
      User::TYPE_NAME[user.user_type.to_s.to_sym]
    end
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
    f.input :email

    f.input :bank_name
    f.input :card
    f.input :cert_id
    f.input :cert_address

    f.input :department
    f.input :user_cate, :as => :select, :collection => User::CATES
    f.input :user_type, :as => :select, :collection => User::TYPE

    #f.input :password
    #f.input :password_confirmation
  end
  
  actions
end

end