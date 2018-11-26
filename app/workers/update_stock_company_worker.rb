class UpdateStockCompanyWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, change_capital_value, is_buy = true, is_new = false)
    company = StockCompany.where(id: company_id).first
    return if company.nil?
    company.stock_num = 0
    if is_buy
      #认购
      company.holders_buy_sum_price += change_capital_value.to_f
      company.capital_sum += change_capital_value.to_i
    else
      #赎回
      company.ransom_sum_price += change_capital_value.to_f
      company.capital_sum -= change_capital_value.to_i
    end
    
    num = AccountStatic.stockholders_count(company_id)[company_id]
    company.stockholders_num = num.to_i
    company.save
  end
end