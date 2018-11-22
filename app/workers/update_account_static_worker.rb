class UpdateAccountStaticWorker
  include Sidekiq::Worker

  def perform(split_id)
    ss = StockSplit.where(id: split_id).first
    if ss
      sas = StockAccount.where(company_id: ss.company_id, visible: true).where("published_at <= ?", ss.published_at)
      transfer_ratio = (ss.stock_transfer.to_f.round(2) + ss.stock_send.to_f.round(2))/10.0
      bonus_ratio = ss.stock_bonus.to_f.round(2)/10.0
      sas.each do |sa|
      	acs = AccountStatic.where(user_id: sa.user_id, company_id: ss.company_id).first
      	unless acs
      	  acs = AccountStatic.new(user_id: sa.user_id, company_id: ss.company_id, stock_sum: sa.stock_sum)
      	end
        if bonus_ratio > 0
          acs.stock_bonus += (acs.stock_sum * bonus_ratio).round(2)
        end
      	if transfer_ratio > 0
      	  acs.stock_sum += (acs.stock_sum * transfer_ratio).to_i
      	end
        acs.save if acs.valid?
      end
      breo_stock_sum = AccountStatic.where(company_id: ss.company_id).sum(:breo_stock_num)
      if breo_stock_sum > 0 
        AccountStatic.all.each do |as|
          as.update_column(:current_breo_stock_percentage, (as.breo_stock_num*100/breo_stock_sum.to_f).round(4))
        end
      end
    end
  end
end