class CreateStockAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_accounts do |t|
    	t.integer  "user_id",          limit: 4
    	t.integer  "company_id",       limit: 6
    	t.integer  "stock_sum",        limit: 6
    	t.float    "stock_price",      limit: 24

		t.boolean  "visible",             default: false
        t.integer  "level",               limit: 4
        t.date     "published_at"
        
        t.datetime "created_at",          null: false
        t.datetime "updated_at",          null: false
    end

    add_index "stock_accounts", ["visible"], name: "index_stock_accounts_on_visible", using: :btree
    add_index "stock_accounts", ["user_id", "visible"], name: "index_stock_accounts_on_user_visible", using: :btree
    add_index "stock_accounts", ["company_id"], name: "index_stock_accounts_on_company_id", using: :btree
    add_index "stock_accounts", ["user_id", "company_id"], name: "index_stock_accounts_on_user_company_info", using: :btree
  end
end