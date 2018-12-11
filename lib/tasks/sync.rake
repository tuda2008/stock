namespace :sync do
  desc 'sync datas'

  task static: :environment do
    p "==========start=========="
    ss = StockStatic.select("company_id, user_id, stock_type, sum(breo_stock_num) as sum_breo_stock_num, 
      sum(breo_stock_percentage) as sum_breo_stock_percentage, sum(capital_sum) as sum_capital_sum, 
      sum(capital_percentage) as sum_capital_percentage, sum(stock_sum_price) as sum_stock_sum_price").group(:company_id, :user_id, :stock_type).order("stock_type")
    AccountStatic.all.each do |acs|
      ss.each do |static|
        if static.user_id.to_i == acs.user_id.to_i
          if static.stock_type == StockStatic::STOCK_BUY
            acs.breo_stock_num = static.sum_breo_stock_num.to_i
            acs.breo_stock_percentage = static.sum_breo_stock_percentage.to_f
            acs.stock_sum_price = static.sum_stock_sum_price.to_f
            acs.capital_sum = static.sum_capital_sum.to_f
          else 
            acs.breo_stock_num -= static.sum_breo_stock_num.to_i
            acs.breo_stock_percentage -= static.sum_breo_stock_percentage.to_f
            acs.stock_sum_price -= static.sum_stock_sum_price.to_f
            acs.capital_sum -= static.sum_capital_sum.to_f
            acs.ransom_stock_num = static.sum_stock_sum_price.to_f
            acs.ransom_sum_price = static.sum_capital_sum.to_f
          end
          acs.save if acs.valid?
        end
      end
    end

    sc = StockCompany.where(id: 1).first
    if sc && sc.breo_stock_num > 0 
      AccountStatic.where(company_id: 1).each do |as|
        as.update_column(:current_company_stock_percentage, (as.breo_stock_num*100/sc.breo_stock_num.to_f).round(4))
      end
    end

    breo_stock_sum = StockCompany.sum(:breo_stock_num)
    if breo_stock_sum > 0 
      AccountStatic.all.each do |as|
        as.update_column(:current_breo_stock_percentage, (as.breo_stock_num*100/breo_stock_sum.to_f).round(4))
      end
    end
    p "==========end=========="
  end
end