class CreateStockCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_companies do |t|
        t.string   "name",                limit: 255

        t.string   "description",         limit: 255
        t.string   "legal_representative",limit: 255

        t.date     "published_at"
        t.boolean  "visible",             default: true
        
        t.datetime "created_at",          null: false
        t.datetime "updated_at",          null: false
    end

    add_index "stock_companies", ["name"], name: "index_stock_companies_on_name", unique: true, using: :btree
    add_index "stock_companies", ["visible"], name: "index_stock_companies_on_visible", using: :btree
  end
end