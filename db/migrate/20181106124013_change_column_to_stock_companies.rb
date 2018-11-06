class ChangeColumnToStockCompanies < ActiveRecord::Migration[5.2]
  def change
    rename_column :stock_companies, :estimate_market_price, :capital_sum
  end
end