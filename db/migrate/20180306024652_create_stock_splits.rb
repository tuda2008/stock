class CreateStockSplits < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_splits do |t|
    	t.integer  "company_id",          limit: 4
    	t.integer  "stock_transfer",      limit: 4
    	t.integer  "stock_send",          limit: 4
    	t.float    "stock_bonus",         limit: 10

    	t.string   "info",                limit: 255
        t.date     "published_at"
        t.boolean  "enabled",             default: false

	   	t.datetime "created_at",          null: false
	    t.datetime "updated_at",          null: false
    end

    add_index "stock_splits", ["company_id"], name: "index_stock_splits_on_company_id", using: :btree
    add_index "stock_splits", ["enabled"], name: "index_stock_splits_on_enabled", using: :btree
  end
end