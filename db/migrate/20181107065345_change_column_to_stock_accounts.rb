class ChangeColumnToStockAccounts < ActiveRecord::Migration[5.2]
  def change
  	change_column :stock_accounts, :breo_stock_num, :integer
  	change_column :stock_accounts, :capital_sum, :integer
  end
end