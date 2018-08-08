class CreateJournalDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :journal_details do |t|
    	t.integer "journal_id", default: 0, null: false
    	t.string "prop_key", limit: 30, default: "", null: false
    	t.string "old_value"
    	t.string "value"
    end

    add_index "journal_details", ["journal_id"], name: "journal_details_journal_id"
  end
end