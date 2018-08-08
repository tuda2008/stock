class UpdateStockAccountHistoryWorker
  include Sidekiq::Worker

  def perform(stock_id, value_changes_hash)
    sa = StockAccount.where(id: stock_id).first
    if sa
      journal = Journal.new(:journalized => sa, :user => sa.user)
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