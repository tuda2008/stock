class AddColumnToAccountStatics < ActiveRecord::Migration[5.2]
  def change
  	add_column :account_statics, :ransom_stock_num, :integer, default: 0
  	add_column :account_statics, :ransom_sum_price, :float, default: 0, limit: 10
  end
end