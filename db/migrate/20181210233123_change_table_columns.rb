class ChangeTableColumns < ActiveRecord::Migration[5.2]
  def change
  	change_column :stock_accounts, :stock_price, :decimal, precision: 5, scale: 2
  	change_column :stock_accounts, :stock_sum_price, :decimal, precision: 20, scale: 1
  	change_column :stock_accounts, :breo_stock_num, :bigint
  	change_column :stock_accounts, :breo_stock_percentage, :decimal, precision: 8, scale: 4
  	change_column :stock_accounts, :capital_sum, :decimal, precision: 20, scale: 1
  	change_column :stock_accounts, :capital_percentage, :decimal, precision: 8, scale: 4
  	change_column :stock_accounts, :register_price, :decimal, precision: 5, scale: 2
  	change_column :stock_accounts, :register_sum_price, :decimal, precision: 20, scale: 1
  	change_column :stock_accounts, :investment_price, :decimal, precision: 5, scale: 2
  	change_column :stock_accounts, :investment_sum_price, :decimal, precision: 20, scale: 1

    change_column :ransom_stocks, :stock_price, :decimal, precision: 5, scale: 2
    change_column :ransom_stocks, :stock_sum_price, :decimal, precision: 20, scale: 1
    change_column :ransom_stocks, :breo_stock_num, :bigint
    change_column :ransom_stocks, :breo_stock_percentage, :decimal, precision: 8, scale: 4
    change_column :ransom_stocks, :capital_sum, :decimal, precision: 20, scale: 1
    change_column :ransom_stocks, :capital_percentage, :decimal, precision: 8, scale: 4
    change_column :ransom_stocks, :register_price, :decimal, precision: 5, scale: 2
    change_column :ransom_stocks, :register_sum_price, :decimal, precision: 20, scale: 1
    
    change_column :ransom_stocks, :tax, :decimal, precision: 18, scale: 2
    change_column :ransom_stocks, :sum_price_after_tax, :decimal, precision: 20, scale: 2

    change_column :stock_statics, :stock_price, :decimal, precision: 5, scale: 2
    change_column :stock_statics, :stock_sum_price, :decimal, precision: 20, scale: 1
    change_column :stock_statics, :breo_stock_num, :bigint
    change_column :stock_statics, :breo_stock_percentage, :decimal, precision: 8, scale: 4
    change_column :stock_statics, :capital_sum, :decimal, precision: 20, scale: 1
    change_column :stock_statics, :capital_percentage, :decimal, precision: 8, scale: 4
    change_column :stock_statics, :register_price, :decimal, precision: 5, scale: 2
    change_column :stock_statics, :register_sum_price, :decimal, precision: 20, scale: 1
    
    change_column :stock_companies, :capital_sum, :decimal, precision: 20, scale: 1
  	change_column :stock_companies, :holders_buy_sum_price, :decimal, precision: 20, scale: 1
  	change_column :stock_companies, :ransom_sum_price, :decimal, precision: 20, scale: 1
    change_column :stock_companies, :holders_stock_num, :decimal, precision: 20, scale: 1
    change_column :stock_companies, :ransom_stock_num, :decimal, precision: 20, scale: 1
    change_column :stock_companies, :holders_stock_sum_price, :decimal, precision: 20, scale: 1
    change_column :stock_companies, :stock_price, :decimal, precision: 5, scale: 2
    change_column :stock_companies, :stock_num, :decimal, precision: 20, scale: 1
  end
end