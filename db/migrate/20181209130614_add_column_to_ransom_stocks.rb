class AddColumnToRansomStocks < ActiveRecord::Migration[5.2]
  def change
  	add_column :ransom_stocks, :register_status, :integer, limit: 4
  	add_column :ransom_stocks, :register_at, :datetime
  	add_column :ransom_stocks, :meeting_sn, :string, limit: 60, default: ""
    add_column :ransom_stocks, :change_type, :integer, limit: 4
  end
end