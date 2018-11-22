class ChangeColumnToAccountStatics < ActiveRecord::Migration[5.2]
  def change
  	add_column :account_statics, :current_company_stock_percentage, :float,  default: 0, limit: 10
  end
end