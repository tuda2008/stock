ActiveAdmin.register_page "Dashboard" do

menu false
#menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    panel '股东持股汇总' do
      @statics = AccountStatic.all.page(params[:page]).per(10)
      paginated_collection(@statics, download_links: false) do
          table class: "index_table index" do 
              thead do 
                  tr do
                    th class: "col" do 
                      "股东名"
                    end 
                    th class: "col" do 
                      "公司名"
                    end
                    th class: "col" do 
                      "现持股数"
                    end
                    th class: "col" do 
                      "已分红"
                    end
                    th class: "col" do 
                      "已赎回股数"
                    end
                    th class: "col" do 
                      "赎回所得"
                    end
                  end
              end
              tbody do 
                @statics.each do |static|
                  tr class: "even" do
                    td class: "col" do 
                      static.user.name
                    end
                    td class: "col" do 
                      static.stock_company.name
                    end
                    td class: "col" do 
                      static.stock_sum
                    end
                    td class: "col" do 
                      static.stock_bonus.to_f.round(2).to_s + " ¥"
                    end
                    td class: "col" do 
                      static.ransom_stock_num
                    end
                    td class: "col" do 
                      static.ransom_sum_price.to_f.round(2).to_s + " ¥"
                    end
                  end
                end
              end
          end
      end
    end
  end

  sidebar "使用须知" do
    "第一步.在 '系统管理' -> '股东管理' -> '新建股东'<br /> 
     第二步.在 '公司管理' -> '新建公司'<br />
     第三步.在 '股票认购' -> '新建股票认购'<br />
     第四步.在 '分红派股' -> '新建分红派股'<br />".html_safe
  end

end