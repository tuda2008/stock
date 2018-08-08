class UpdateAccountStaticSumWorker
  include Sidekiq::Worker

  def perform(stock_id, sum)
    sa = StockAccount.where(id: stock_id).first
    if sa
        acs = AccountStatic.where(user_id: sa.user_id, company_id: sa.company_id).first
        unless acs
          acs = AccountStatic.new(user_id: sa.user_id, company_id: sa.company_id)
        end
        acs.stock_sum = acs.stock_sum + sum
        acs.save if acs.valid?
    end
  end
end