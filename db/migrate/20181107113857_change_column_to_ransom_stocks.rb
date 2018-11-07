class ChangeColumnToRansomStocks < ActiveRecord::Migration[5.2]
  def change
  	change_column :ransom_stocks, :breo_stock_num, :integer
  	change_column :ransom_stocks, :capital_sum, :integer

  	change_column :stock_statics, :breo_stock_num, :integer
  	change_column :stock_statics, :capital_sum, :integer
  end
end