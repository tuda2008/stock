ActiveAdmin.register_page "StockSplitHistory" do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

#menu priority: 3, label: "股票分红派股历史查询", parent: "历史查询"
menu false

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

content title: '股票分红派股历史查询' do
  panel '最近分红历史' do
    @journals = Journal.stock_split.includes(:user, :details).page(params[:page]).per(10)
    @journals.reload
    paginated_collection(@journals, download_links: false) do
        table class: "index_table index" do 
            thead do 
                tr do
                    th class: "col" do 
                        "股东名"
                    end 
                    th class: "col" do 
                        "历史详情"
                    end
                    th class: "col" do 
                        "操作时间"
                    end
                end
            end
            tbody do 
              @journals.each do |journal|
                arrs = []
                journal.details.each do |detail|
                  arrs << show_detail(detail, 'stock_split')
                end
                  
                tr class: "even" do
                    td class: "col" do 
                        journal.user.name
                    end
                    td class: "col" do 
                        arrs.join(", ")
                    end
                    td class: "col" do 
                        journal.created_at.strftime("%Y-%m-%d %H:%M:%S")
                    end
                end
              end
            end
        end
    end
  end
end


end