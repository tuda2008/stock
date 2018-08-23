class CreateAccountStaticWorker
  include Sidekiq::Worker

  def perform(stock_id)
    sa = StockAccount.where(id: stock_id).first
    if sa
      	acs = AccountStatic.where(user_id: sa.user_id, company_id: sa.company_id).first
      	unless acs
      	  acs = AccountStatic.new(user_id: sa.user_id, company_id: sa.company_id)
      	end
      	acs.stock_sum += sa.stock_sum.to_i
        acs.save if acs.valid?
    end
  end
end