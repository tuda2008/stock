class AddColumnToStockCompanies < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_companies, :stockholders_num, :integer, default: 0

  	add_column :stock_companies, :holders_stock_num, :float, default: 0, limit: 10
  	add_column :stock_companies, :holders_buy_sum_price, :float, default: 0, limit: 10
  	add_column :stock_companies, :ransom_stock_num, :float, default: 0, limit: 8
  	add_column :stock_companies, :ransom_sum_price, :float, default: 0, limit: 10
  	add_column :stock_companies, :holders_stock_sum_price, :float, default: 0, limit: 10
  	add_column :stock_companies, :stock_price, :float, default: 0, limit: 6
  	add_column :stock_companies, :estimate_market_price, :float, default: 0, limit: 10
  end
end