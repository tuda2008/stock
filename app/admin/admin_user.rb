ActiveAdmin.register AdminUser do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :email, :password, :password_confirmation

menu priority: 6, label: "管理员"

actions :all, except: [:destroy]

  filter :email
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  filter :created_at
  
  index do
    selectable_column
    column('#', :id, sortable: false) { |user| link_to user.id, admin_admin_user_path(user) }
    column(:email, sortable: false) { |user| link_to user.email, admin_admin_user_path(user) }
    column(:current_sign_in_at) do |user|
      user.current_sign_in_at.nil? ? "" : user.current_sign_in_at.strftime("%Y-%m-%d %H:%M:%S")
    end
    column :current_sign_in_ip, sortable: false
    column(:last_sign_in_at) do |user|
      user.current_sign_in_at.nil? ? "" : user.last_sign_in_at.strftime("%Y-%m-%d %H:%M:%S")
    end
    column :last_sign_in_ip, sortable: false
    column :sign_in_count
    actions defaults: false do |user|
      item "    编辑", edit_admin_admin_user_path(user)
    end
  end
  
  show do 
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row(:current_sign_in_at) do |user|
        user.current_sign_in_at.nil? ? "" : user.current_sign_in_at.strftime("%Y-%m-%d %H:%M:%S")
      end
      row :current_sign_in_ip
      row(:last_sign_in_at) do |user|
        user.last_sign_in_at.nil? ? "" : user.last_sign_in_at.strftime("%Y-%m-%d %H:%M:%S")
      end
      row :last_sign_in_ip
    end
  end
  
  form do |f|
    f.inputs "管理员信息" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end