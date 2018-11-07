class UpdateStockCompanyWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, change_capital_value, is_buy = true, is_new = false)
    company = StockCompany.where(id: company_id).first
    return if company.nil?
    company.stock_num = 0
    if is_buy
      #认购
      company.stockholders_num += 1 if is_new
      company.holders_buy_sum_price += change_capital_value
      company.capital_sum += change_capital_value
    else
      #赎回
      company.ransom_sum_price += change_capital_value
      company.capital_sum -= change_capital_value
    end
    
    as = AccountStatic.where(user_id: user_id, company_id: company_id).first
    company.stockholders_num -= 1 if as && as.breo_stock_num.to_i == 0
    company.save
  end
end