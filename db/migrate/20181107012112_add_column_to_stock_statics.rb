class AddColumnToStockStatics < ActiveRecord::Migration[5.2]
  def change
  	add_column :stock_statics, :ori_id, :integer, null: false
  	add_index "stock_statics", ["stock_type", "ori_id"], name: "index_stock_statics_on_ori_type", using: :btree
  end
end