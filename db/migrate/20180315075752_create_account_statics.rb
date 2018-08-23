class CreateAccountStatics < ActiveRecord::Migration[5.1]
  def change
    create_table :account_statics do |t|
    	t.integer  "user_id",          limit: 4
    	t.integer  "company_id",       limit: 6
    	t.integer  "breo_stock_num",   default: 0
        t.float    "breo_stock_percentage",  default: 0, limit: 24
        t.float    "investment_sum_price",   default: 0, limit: 24
        t.float    "capital_sum",   default: 0, limit: 24
        t.float    "stock_sum_price",  default: 0, limit: 24
    	t.float    "stock_bonus",      default: 0, limit: 24
        
        t.timestamps
    end

    add_index "account_statics", ["user_id"], name: "index_account_statics_on_user_id", using: :btree
    add_index "account_statics", ["company_id"], name: "index_account_statics_on_company_id", using: :btree
    add_index "account_statics", ["user_id", "company_id"], name: "index_account_statics_on_user_company", using: :btree
  end
end