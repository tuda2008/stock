class UpdateAccountStockSumWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, stock_sum, stock_sum_price)
      acs = AccountStatic.where(user_id: user_id, company_id: company_id).first
      if acs
        acs.stock_sum = acs.stock_sum + stock_sum
        acs.ransom_stock_num = acs.ransom_stock_num - stock_sum
        acs.ransom_sum_price = acs.ransom_sum_price - stock_sum_price
        acs.save if acs.valid?
      end
  end
end