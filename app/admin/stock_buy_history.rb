ActiveAdmin.register_page "StockBuyHistory" do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#


menu priority: 1, label: "股票认购历史查询", parent: "历史查询"

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

content title: '股票认购历史查询' do
  panel '最近认购历史' do
    @journals = Journal.stock_account.includes(:admin_user, :details).page(params[:page]).per(10)
    @journals.reload
    paginated_collection(@journals, download_links: false) do
        table class: "index_table index" do 
            thead do 
                tr do
                    th class: "col" do 
                        "操作员"
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
                  arrs << show_detail(detail, 'stock_account')
                end
                  
                tr class: "even" do
                    td class: "col" do 
                        journal.admin_user.email
                    end
                    td class: "col" do 
                        #link_to("#{arrs.first(2).join(", ")}......", admin_journal_path(journal), remote: true)
                        arrs.size > 2 ? link_to("#{arrs.first(2).join(", ")}......", admin_journal_path(journal)) : arrs.join(", ")
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

action_item :detail do
end

end