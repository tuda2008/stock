class CreateStockAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_accounts do |t|
    	t.integer  "user_id",          limit: 4
    	t.integer  "company_id",       limit: 6
    	t.integer  "stock_sum",        limit: 6    #实际入股总数
    	t.float    "stock_price",      limit: 24   #实际入股单价
        t.float    "stock_sum_price",  limit: 24   #实际入股金额

        t.float    "breo_stock_num",        limit: 24 #增加倍轻松股份数
        t.float    "breo_stock_percentage", limit: 24 #增加倍轻松股份占比

        t.float    "capital_sum",           limit: 24 #增加所持公司工商登记出资额
        t.float    "capital_percentage",    limit: 24 #增加所持公司工商登记出资比例

        t.float    "register_price",        limit: 24 #工商登记入股单价
        t.float    "register_sum_price",    limit: 24 #工商登记入股金额
        t.integer  "register_status",       limit: 4  #工商系统办结状态
        t.date     "register_at"                      #工商系统办结时间

        t.float    "investment_sum_price",  limit: 24 #合约投资金额
        t.date     "investment_at"                    #合约入股时间
        t.date     "transfered_at"                    #投资款到账时间

        t.integer  "change_type",          limit: 4   #变动类别

		t.boolean  "visible",          default: false
 
        t.string   "info",             limit: 255
        
        t.datetime "created_at",          null: false
        t.datetime "updated_at",          null: false
    end

    add_index "stock_accounts", ["visible"], name: "index_stock_accounts_on_visible", using: :btree
    add_index "stock_accounts", ["user_id", "visible"], name: "index_stock_accounts_on_user_visible", using: :btree
    add_index "stock_accounts", ["company_id"], name: "index_stock_accounts_on_company_id", using: :btree
    add_index "stock_accounts", ["user_id", "company_id"], name: "index_stock_accounts_on_user_company_info", using: :btree
    add_index "stock_accounts", ["change_type"], name: "index_stock_accounts_on_change_type", using: :btree
  end
end