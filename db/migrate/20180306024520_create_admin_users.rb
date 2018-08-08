class CreateAdminUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_users do |t|
	    t.string   "email",                  limit: 255, default: "", null: false
	    t.string   "encrypted_password",     limit: 255, default: "", null: false
	    t.string   "reset_password_token",   limit: 255
	    t.datetime "reset_password_sent_at"
	    t.datetime "remember_created_at"
	    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
	    t.datetime "current_sign_in_at"
	    t.datetime "last_sign_in_at"
	    t.string   "current_sign_in_ip",     limit: 255
	    t.string   "last_sign_in_ip",        limit: 255
	    t.datetime "created_at",             null: false
	    t.datetime "updated_at",             null: false
    end

    add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  	add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end
end
