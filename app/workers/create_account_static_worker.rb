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
        acs.breo_stock_percentage += sa.breo_stock_percentage.to_f
        acs.investment_sum_price += sa.investment_sum_price.to_f
        acs.capital_sum += sa.capital_sum.to_f
        acs.stock_sum_price += sa.stock_sum_price.to_f
      	
        acs.save if acs.valid?

        company_stock_sum = AccountStatic.where(company_id: sa.company_id).sum(:breo_stock_num)
        if company_stock_sum > 0 
          AccountStatic.where(company_id: sa.company_id).each do |as|
            as.update_column(:current_company_stock_percentage, (as.breo_stock_num*100/company_stock_sum.to_f).round(4))
          end
        end

        breo_stock_sum = AccountStatic.sum(:breo_stock_num)
        if breo_stock_sum > 0 
          AccountStatic.all.each do |as|
            as.update_column(:current_breo_stock_percentage, (as.breo_stock_num*100/breo_stock_sum.to_f).round(4))
          end
        end
    end
  end
end