class CreateStockStatics < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_statics do |t|
        t.integer  "user_id",          limit: 4
    	t.integer  "company_id",       limit: 6
    	t.integer  "stock_type",       limit: 4, default: 1  #1认购，2赎回
    	t.float    "stock_price",      limit: 24   #实际入股/退出单价
        t.float    "stock_sum_price",  limit: 24   #实际入股/退出金额

        t.float    "breo_stock_num",        limit: 24 #增加/退出倍轻松股份数
        t.float    "breo_stock_percentage", limit: 24 #增加/退出倍轻松股份占比

        t.float    "capital_sum",           limit: 24 #增加/退出所持公司工商登记出资额
        t.float    "capital_percentage",    limit: 24 #增加/退出所持公司工商登记出资比例

        t.float    "register_price",        limit: 24 #工商登记入股/退出单价
        t.float    "register_sum_price",    limit: 24 #工商登记入股/退出金额
        t.integer  "register_status",       limit: 4  #工商系统办结状态

        t.string   "meeting_sn",           limit: 60, default: "" #股东会决议编号
        t.integer  "change_type",          limit: 4   #变动类别
        t.string   "info",                 limit: 255

        t.timestamps
    end

    add_index "stock_statics", ["user_id"], name: "index_stock_statics_on_user_id", using: :btree
    add_index "stock_statics", ["company_id"], name: "index_stock_statics_on_company_id", using: :btree
    add_index "stock_statics", ["stock_type"], name: "index_stock_statics_on_stock_type", using: :btree
    add_index "stock_statics", ["user_id", "stock_type"], name: "index_stock_statics_on_us_type", using: :btree
    add_index "stock_statics", ["company_id", "stock_type"], name: "index_stock_statics_on_cs_type", using: :btree
    add_index "stock_statics", ["user_id", "company_id", "stock_type"], name: "index_stock_statics_on_ucs_type", using: :btree
    add_index "stock_statics", ["register_status"], name: "index_stock_statics_on_register_status", using: :btree
    add_index "stock_statics", ["meeting_sn"], name: "index_stock_statics_on_meeting_sn", using: :btree
    add_index "stock_statics", ["change_type"], name: "index_stock_statics_on_change_type", using: :btree
  end
end