class ChangeStockCompaniesColumn < ActiveRecord::Migration[5.2]
  def change
  	change_column :stock_companies, :capital_sum, :decimal, precision: 10, scale: 1
  	change_column :stock_companies, :holders_buy_sum_price, :decimal, precision: 10, scale: 1
  	change_column :stock_companies, :ransom_sum_price, :decimal, precision: 10, scale: 1
  end
end