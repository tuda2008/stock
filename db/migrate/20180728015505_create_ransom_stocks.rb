class CreateRansomStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :ransom_stocks do |t|
    	t.integer  "user_id",             limit: 4
    	t.integer  "company_id",          limit: 4
    	t.integer  "stock_num",           limit: 6
    	t.float    "stock_price",         limit: 10   #实际退出单价
      t.float    "stock_sum_price",     limit: 24   #实际退出金额

      t.float    "breo_stock_num",        limit: 24 #退出倍轻松股份数
      t.float    "breo_stock_percentage", limit: 24 #退出倍轻松股份占比

      t.float    "capital_sum",           limit: 24 #退出所持公司工商登记出资额
      t.float    "capital_percentage",    limit: 24 #退出所持公司工商登记出资比例

      t.float    "register_price",        limit: 24 #工商登记退出单价
      t.float    "register_sum_price",    limit: 24 #工商登记退出金额


      t.float    "tax",                   limit: 24 #个人所得税
      t.float    "sum_price_after_tax",   limit: 24 #税后实际股权款
      t.date     "published_at"                     #实际支付股权款时间
      t.date     "tax_payed_at"                     #实际缴纳税收时间

    	t.string   "info",                limit: 255
   
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