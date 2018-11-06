ActiveAdmin.register StockStatic do

actions :index


filter :user
filter :stock_company
filter :stock_price
filter :stock_sum_price
filter :breo_stock_num
filter :breo_stock_percentage
filter :capital_sum
filter :capital_percentage
filter :register_price
filter :register_sum_price
filter :register_status
filter :meeting_sn
filter :change_type
filter :info


menu priority: 1, label: "持股汇总"


scope :all, default: true
scope("所有认购B") { |static| static.buy }
scope("所有赎回S") { |static| static.ransom }

index do
  column "股东名" do |account|
    link_to account.user.name, ""
  end
  column "公司名" do |account|
    account.stock_company.name
  end
end

csv do
  column "股东名" do |account|
    account.user.name
  end
  column "公司名" do |account|
    account.stock_company.name
  end
end

sidebar "使用须知", :only => [:index] do
    "第一步.在 '系统管理' -> '股东管理' -> '新建股东'<br /> 
     第二步.在 '公司管理' -> '新建公司'<br />
     第三步.在 '股票认购' -> '新建股票认购'<br />
     第四步.在 '股票赎回' -> '新建股票赎回'<br />".html_safe
end

end