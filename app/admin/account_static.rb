ActiveAdmin.register AccountStatic do


actions :index, :show

filter :user
filter :stock_company
filter :stock_sum_price
filter :stock_bonus
filter :ransom_stock_num
filter :ransom_sum_price

menu priority: 1, label: "持股汇总"

controller do
  def index
    index! do |format|
      @statics = AccountStatic.all.reload

      format.html
      format.csv   { export_csv @statics }
      format.json  { render json: @statics }
      format.xml   { render xml: @statics }
    end
  end
end

scope :all, default: true
scope("有赎回Y") { |static| static.ransom }
scope("无赎回N") { |static| static.no_ransom }
scope("大股东B") { |static| static.big }
scope("小股东S") { |static| static.small }

index do
  column "股东名" do |account|
    link_to account.user.name, admin_account_static_path(account.user_id)
  end
  column "公司名" do |account|
    account.stock_company.name
  end
  column "现倍轻松股份占比" do |account|
    account.breo_stock_percentage.to_f.round(4).to_s + " %"
  end
  column "现实际持股金额" do |account|
    account.stock_sum_price.to_f.round(2).to_s + " ¥"
  end
  column "已分红" do |account|
    account.stock_bonus.to_f.round(2).to_s + " ¥"
  end
  column "已赎回股数" do |account|
    account.ransom_stock_num
  end
  column "赎回所得" do |account|
    account.ransom_sum_price.to_f.round(2).to_s + " ¥"
  end
end

show do
    panel '最近认购历史' do
        @journals = Journal.stock_account.where(user_id: params[:id]).includes(:user, :details).page(params[:page]).per(10)
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
                      arrs << show_detail(detail, 'stock_account')
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

    panel '最近分红历史' do
        @journals = Journal.stock_split.where(user_id: params[:id]).includes(:user, :details).page(params[:page]).per(10)
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

    panel '最近赎回历史' do
        @journals = Journal.stock_ransom.where(user_id: params[:id]).includes(:user, :details).page(params[:page]).per(10)
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
                      arrs << show_detail(detail, 'ransom_stock')
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

sidebar "使用须知", :only => [:index] do
    "第一步.在 '系统管理' -> '股东管理' -> '新建股东'<br /> 
     第二步.在 '公司管理' -> '新建公司'<br />
     第三步.在 '股票认购' -> '新建股票认购'<br />
     第四步.在 '分红派股' -> '新建分红派股'<br />".html_safe
end

end