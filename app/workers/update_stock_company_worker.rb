class UpdateStockCompanyWorker
  include Sidekiq::Worker

  def perform(user_id, company_id, change_capital_value, is_buy = true, is_new = false)
    company = StockCompany.where(id: company_id).first
    return if company.nil?
    company.stock_num = 0

    ss = StockStatic.sum_capital(company_id)
    ss.each do |static|
      if static.stock_type == StockStatic::STOCK_BUY
        company.holders_buy_sum_price = static.sum_capital_sum.to_f
        company.capital_sum = static.sum_capital_sum.to_f
      else
        company.ransom_sum_price = static.sum_capital_sum.to_f
        company.capital_sum -= static.sum_capital_sum.to_f
      end
    end

    ssn = StockStatic.sum_breo_stock_num_by_company(company_id)
    ssn.each do |static|
      if static.stock_type == StockStatic::STOCK_BUY
        company.breo_stock_num = static.sum_breo_stock_num.to_f
      else 
        company.breo_stock_num -= static.sum_breo_stock_num.to_f
      end
    end
    
    num = AccountStatic.stockholders_count(company_id)[company_id]
    company.stockholders_num = num.to_i
    company.save
  end
end