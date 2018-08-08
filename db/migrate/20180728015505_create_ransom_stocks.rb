class CreateRansomStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :ransom_stocks do |t|
    	t.integer  "user_id",             limit: 4
    	t.integer  "company_id",          limit: 4
    	t.integer  "stock_num",           limit: 6
    	t.float    "stock_price",         limit: 10

    	t.string   "info",                limit: 255
      t.date     "published_at"
      t.boolean  "visible",             default: false

	   	t.datetime "created_at",          null: false
	    t.datetime "updated_at",          null: false
    end

    add_index "ransom_stocks", ["user_id"], name: "index_ransom_stocks_on_user_id", using: :btree
    add_index "ransom_stocks", ["company_id"], name: "index_ransom_stocks_on_company_id", using: :btree
  	add_index "ransom_stocks", ["user_id", "company_id"], name: "index_ransom_stocks_on_user_company", using: :btree
    add_index "ransom_stocks", ["visible"], name: "index_ransom_stocks_on_visible", using: :btree
  end
end