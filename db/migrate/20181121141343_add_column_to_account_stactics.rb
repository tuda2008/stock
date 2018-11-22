class AddColumnToAccountStactics < ActiveRecord::Migration[5.2]
  def change
  	add_column :account_statics, :current_breo_stock_percentage, :float,  default: 0, limit: 10
  end
end