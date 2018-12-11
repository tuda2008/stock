class AddColumnBreoStockNumToStockCompanies < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_companies, :breo_stock_num, :decimal, precision: 20, scale: 1
  end
end