class UpdateStockAccountHistoryWorker
  include Sidekiq::Worker

  def perform(user_id, stock_id, value_changes_hash)
    sa = StockAccount.where(id: stock_id).first
    if sa
      journal = Journal.new(:journalized => sa, :user_id => user_id)
      value_changes_hash.each do |key, val|
      	journal.details << JournalDetail.new(
	        :prop_key => key,
	        :old_value => val[0],
	        :value => val[1]
	      )
      end
      journal.save
    end
  end
end