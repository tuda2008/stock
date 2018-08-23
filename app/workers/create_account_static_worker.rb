class CreateAccountStaticWorker
  include Sidekiq::Worker

  def perform(stock_id)
    sa = StockAccount.where(id: stock_id).first
    if sa
      	acs = AccountStatic.where(user_id: sa.user_id, company_id: sa.company_id).first
      	unless acs
      	  acs = AccountStatic.new(user_id: sa.user_id, company_id: sa.company_id)
      	end
        acs.breo_stock_num += sa.breo_stock_num.to_i
        acs.stock_sum_price += sa.stock_sum_price.to_f
      	acs.breo_stock_percentage += sa.breo_stock_percentage.to_f
        acs.save if acs.valid?
    end
  end
end