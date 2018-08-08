class CreateJournals < ActiveRecord::Migration[5.1]
  def change
    create_table :journals do |t|
    	t.integer  "user_id",                    default: 0, null: false
    	t.integer  "journalized_id",             default: 0, null: false
		t.string   "journalized_type",           limit: 30, default: "", null: false
	   	t.datetime "created_at",                 null: false
    end

    add_index "journals", ["user_id"], name: "index_journals_on_user_id"
    add_index "journals", ["journalized_id"], name: "index_journals_on_journalized_id"
    add_index "journals", ["journalized_type"], name: "journals_journalized_type"
    add_index "journals", ["journalized_id", "journalized_type"], name: "journals_journalized_id"
    add_index "journals", ["created_at"], name: "index_journals_on_created_at"
  end
end