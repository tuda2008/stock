# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_06_124013) do

  create_table "account_statics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.bigint "company_id"
    t.integer "breo_stock_num", default: 0
    t.float "breo_stock_percentage", default: 0.0
    t.float "investment_sum_price", default: 0.0
    t.float "capital_sum", default: 0.0
    t.float "stock_sum_price", default: 0.0
    t.float "stock_bonus", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ransom_stock_num", default: 0
    t.float "ransom_sum_price", default: 0.0
    t.index ["company_id"], name: "index_account_statics_on_company_id"
    t.index ["user_id", "company_id"], name: "index_account_statics_on_user_company"
    t.index ["user_id"], name: "index_account_statics_on_user_id"
  end

  create_table "active_admin_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "journal_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "journal_id", default: 0, null: false
    t.string "prop_key", limit: 30, default: "", null: false
    t.string "old_value"
    t.string "value"
    t.index ["journal_id"], name: "journal_details_journal_id"
  end

  create_table "journals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.integer "journalized_id", default: 0, null: false
    t.string "journalized_type", limit: 30, default: "", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_journals_on_created_at"
    t.index ["journalized_id", "journalized_type"], name: "journals_journalized_id"
    t.index ["journalized_id"], name: "index_journals_on_journalized_id"
    t.index ["journalized_type"], name: "journals_journalized_type"
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "ransom_stocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.bigint "stock_num"
    t.float "stock_price"
    t.float "stock_sum_price"
    t.float "breo_stock_num"
    t.float "breo_stock_percentage"
    t.float "capital_sum"
    t.float "capital_percentage"
    t.float "register_price"
    t.float "register_sum_price"
    t.float "tax"
    t.float "sum_price_after_tax"
    t.date "published_at"
    t.date "tax_payed_at"
    t.string "info"
    t.boolean "visible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_ransom_stocks_on_company_id"
    t.index ["user_id", "company_id"], name: "index_ransom_stocks_on_user_company"
    t.index ["user_id"], name: "index_ransom_stocks_on_user_id"
    t.index ["visible"], name: "index_ransom_stocks_on_visible"
  end

  create_table "stock_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.bigint "company_id"
    t.bigint "stock_sum"
    t.float "stock_price"
    t.float "stock_sum_price"
    t.float "breo_stock_num"
    t.float "breo_stock_percentage"
    t.float "capital_sum"
    t.float "capital_percentage"
    t.float "register_price"
    t.float "register_sum_price"
    t.integer "register_status"
    t.date "register_at"
    t.float "investment_sum_price"
    t.date "investment_at"
    t.date "transfered_at"
    t.integer "change_type"
    t.boolean "visible", default: false
    t.string "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meeting_sn", limit: 30, default: ""
    t.float "investment_price"
    t.datetime "ransom_at"
    t.index ["change_type"], name: "index_stock_accounts_on_change_type"
    t.index ["company_id"], name: "index_stock_accounts_on_company_id"
    t.index ["user_id", "company_id"], name: "index_stock_accounts_on_user_company_info"
    t.index ["user_id", "visible"], name: "index_stock_accounts_on_user_visible"
    t.index ["visible"], name: "index_stock_accounts_on_visible"
  end

  create_table "stock_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "legal_representative"
    t.date "published_at"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stockholders_num", default: 0
    t.float "holders_stock_num", default: 0.0
    t.float "holders_buy_sum_price", default: 0.0
    t.float "ransom_stock_num", default: 0.0
    t.float "ransom_sum_price", default: 0.0
    t.float "holders_stock_sum_price", default: 0.0
    t.float "stock_price", default: 0.0
    t.float "capital_sum", default: 0.0
    t.float "stock_num", default: 0.0
    t.index ["name"], name: "index_stock_companies_on_name", unique: true
    t.index ["visible"], name: "index_stock_companies_on_visible"
  end

  create_table "stock_splits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "company_id"
    t.integer "stock_transfer"
    t.integer "stock_send"
    t.float "stock_bonus"
    t.string "info"
    t.date "published_at"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_stock_splits_on_company_id"
    t.index ["enabled"], name: "index_stock_splits_on_enabled"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "mobile"
    t.string "name"
    t.string "bank_name"
    t.string "card"
    t.string "cert_id"
    t.string "cert_address"
    t.string "department"
    t.integer "user_cate", default: 1, null: false
    t.integer "user_type", default: 1, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cert_id"], name: "index_users_on_cert_id", unique: true
    t.index ["department"], name: "index_users_on_department"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile"], name: "index_users_on_mobile", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["user_cate", "user_type"], name: "index_users_on_user_cate_and_user_type"
    t.index ["user_cate"], name: "index_users_on_user_cate"
    t.index ["user_type"], name: "index_users_on_user_type"
  end

end
