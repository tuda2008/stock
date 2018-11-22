ActiveAdmin.register AccountStatic do

menu false

actions :index

filter :user
filter :stock_company
filter :breo_stock_num
filter :current_breo_stock_percentage
filter :current_company_stock_percentage

index do
  column :company_id do |stock|
    stock.stock_company.name
  end
  column :user_id do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num do |stock|
    number_to_currency(stock.breo_stock_num, unit: '',  precision: 0)
  end
  column :current_breo_stock_percentage do |stock|
    stock.current_breo_stock_percentage.to_f.round(4).to_s + " %"
  end
  column :current_company_stock_percentage do |stock|
    stock.current_company_stock_percentage.to_f.round(4).to_s + " %"
  end
end

csv do
  column :company_id do |stock|
    stock.stock_company.name
  end
  column :user_id do |stock|
    stock.user.name + " " + stock.user.cert_id
  end
  column :breo_stock_num do |stock|
    number_to_currency(stock.breo_stock_num, unit: '',  precision: 0)
  end
  column :current_breo_stock_percentage do |stock|
    stock.current_breo_stock_percentage.to_f.round(4).to_s + " %"
  end
  column :current_company_stock_percentage do |stock|
    stock.current_company_stock_percentage.to_f.round(4).to_s + " %"
  end
end

end