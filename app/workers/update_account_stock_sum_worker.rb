class UpdateAccountStockSumWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, breo_stock_num, breo_stock_percentage, stock_sum_price, capital_sum)
      acs = AccountStatic.where(user_id: user_id, company_id: company_id).first
      if acs
        acs.breo_stock_num += breo_stock_num
        acs.breo_stock_percentage += breo_stock_percentage
        acs.stock_sum_price += stock_sum_price
        acs.capital_sum += capital_sum
        acs.ransom_stock_num = acs.ransom_stock_num - breo_stock_num
        acs.ransom_sum_price = acs.ransom_sum_price 
        acs.save if acs.valid?
      end
  end
end