class UpdateStockSplitHistoryWorker
  include Sidekiq::Worker

  def perform(user_id, split_id, value_changes_hash)
    ss = StockSplit.where(id: split_id).first
    if ss
      sas = StockAccount.where(company_id: ss.company_id, visible: true).where("published_at <= ?", ss.published_at)
      sas.each do |sa|
        journal = Journal.new(:journalized => ss, :user_id => user_id)
        value_changes_hash.each do |key, val|
          if ["stock_transfer", "stock_send", "stock_bonus"].include?(key)
            next if val[0].blank? && val[1] == 0
          end
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
end