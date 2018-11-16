class AddColumnToRansomStockAccounts < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_accounts, :archived_at, :datetime
  	add_column :ransom_stocks, :archived_at, :datetime
  end
end