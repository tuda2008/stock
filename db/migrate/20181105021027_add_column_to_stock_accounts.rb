class AddColumnToStockAccounts < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_accounts, :meeting_sn, :string, limit: 60, default: ""
  	add_column :stock_accounts, :investment_price, :float, limit: 10
  	add_column :stock_accounts, :ransom_at, :datetime
  end
end