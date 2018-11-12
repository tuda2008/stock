ActiveAdmin.register StockStatic do

actions :index


filter :user
filter :stock_company
filter :breo_stock_num
filter :breo_stock_percentage
filter :stock_price
filter :stock_sum_price
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
  column :company_id do |stock|
    link_to_if(stock.stock_type == StockStatic::STOCK_BUY, stock.stock_company.name, admin_stock_account_path(stock.ori_id)) do
      link_to(stock.stock_company.name, admin_ransom_stock_path(stock.ori_id))
    end
  end
  column :user_id do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num
  column :breo_stock_percentage
  column :stock_price
  column :stock_sum_price
  column :capital_sum
  column :capital_percentage
  column :register_price
  column :register_sum_price
  column :register_status do |stock|
    StockAccount::STATUSES_NAME[stock.register_status.to_s.to_sym]
  end
  column :meeting_sn
  column :change_type do |stock|
    StockAccount::TYPES_NAME[stock.change_type.to_s.to_sym]
  end
  column :info
end

csv do
  column :company_id do |stock|
    stock.stock_company.name
  end
  column :user_id do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num
  column :breo_stock_percentage
  column :stock_price
  column :stock_sum_price
  column :capital_sum
  column :capital_percentage
  column :register_price
  column :register_sum_price
  column :register_status do |stock|
    StockAccount::STATUSES_NAME[stock.register_status.to_s.to_sym]
  end
  column :meeting_sn
  column :change_type do |stock|
    StockAccount::TYPES_NAME[stock.change_type.to_s.to_sym]
  end
  column :info
  column "认购/赎回" do |stock|
    stock.stock_type == StockStatic::STOCK_BUY ? "认购" : "赎回"
  end
end

sidebar "使用须知", :only => [:index] do
    "第一步.在 '系统管理' -> '股东管理' -> '新建股东'<br /> 
     第二步.在 '公司管理' -> '新建公司'<br />
     第三步.在 '股票认购' -> '新建股票认购'<br />
     第四步.在 '股票赎回' -> '新建股票赎回'<br />".html_safe
end

end