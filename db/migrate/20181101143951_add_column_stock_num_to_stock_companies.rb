class AddColumnStockNumToStockCompanies < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_companies, :stock_num, :float, default: 1, limit: 10
  end
end