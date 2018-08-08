ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, [:name, :mobile, :email, :card, :cert_id, :password, :password_confirmation], :on, :model

actions :all, except: [:destroy]

menu priority: 3, label: "股东管理", parent: "系统管理"

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
filter :email
filter :mobile
filter :name
filter :cert_id

scope :all, default: true

scope '正常股东', :unlocked do |users|
  users.where("locked_at is null")
end

index do
  selectable_column
  column("#", :id) { |user| link_to user.id, admin_user_path(user) }
  column(:email, sortable: false) do |user|
    user.email
  end
  column :name
  column :mobile, sortable: false
  column :card
  column :cert_id
  column "账号是否正常" do |user|
    user.locked_at.blank? ? "正常" : "已冻结于 " + user.locked_at.to_s
  end
  
  
  actions defaults: false do |user|

    item "    编辑", edit_admin_user_path(user)
  end
  
end



show do
  attributes_table do
    row :id
    row :email
    row :name
    row :mobile
    row :card
    row :cert_id
    row :locked_at do |user|
      user.locked_at.blank? ? "正常用户，未冻结" : "已冻结于 " + user.locked_at.to_s
    end
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs "股东信息" do
    f.input :email
    f.input :name
    f.input :mobile
    f.input :password
    f.input :password_confirmation
    f.input :card
    f.input :cert_id
  end
  
  actions
end


end
