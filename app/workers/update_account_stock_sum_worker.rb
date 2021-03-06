class UpdateAccountStockSumWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, breo_stock_num, breo_stock_percentage, stock_sum_price, capital_sum)
      acs = AccountStatic.where(user_id: user_id, company_id: company_id).first
      if acs
        acs.breo_stock_num += breo_stock_num.to_i
        acs.breo_stock_percentage += breo_stock_percentage.to_f
        acs.stock_sum_price += stock_sum_price.to_f
        acs.capital_sum += capital_sum.to_f
        acs.ransom_stock_num = acs.ransom_stock_num - breo_stock_num.to_i
        acs.ransom_sum_price = acs.ransom_sum_price.to_f 
        acs.save if acs.valid?

        sc = StockCompany.where(id: company_id).first
        if sc && sc.breo_stock_num > 0 
          AccountStatic.where(company_id: company_id).each do |as|
            as.update_column(:current_company_stock_percentage, (as.breo_stock_num*100/sc.breo_stock_num.to_f).round(4))
          end
        end

        breo_stock_sum = StockCompany.sum(:breo_stock_num)
        if breo_stock_sum > 0 
          AccountStatic.all.each do |as|
            as.update_column(:current_breo_stock_percentage, (as.breo_stock_num*100/breo_stock_sum.to_f).round(4))
          end
        end
      end
  end
end