class UpdateStockStaticWorker
  include Sidekiq::Worker

  def perform(id, is_buy = true)
    if is_buy
      sa = StockAccount.where(id: id).first
      return if sa.nil?
      if sa.visible == true
        ss = StockStatic.where(ori_id: id, stock_type: StockStatic::STOCK_BUY).first
        ss = StockStatic.new(ori_id: id, stock_type: StockStatic::STOCK_BUY) if ss.nil?
        ##更新
        ss.attributes = ss.attributes.merge(sa.attributes.clone.slice(
          'user_id', 'company_id',
          'breo_stock_num', 'breo_stock_percentage',
          'stock_price', 'stock_sum_price', 'capital_sum',
          'capital_percentage', 'register_price', 'register_sum_price',
          'register_status', 'meeting_sn', 'change_type', 'info'))
        ss.save if ss.valid?
      else
        ss = StockStatic.where(ori_id: id, stock_type: StockStatic::STOCK_BUY).first
        unless ss.nil?
          ##重置
          ss.attributes = ss.attributes.merge({
            breo_stock_num: 0, breo_stock_percentage:0,
            stock_price: 0, stock_sum_price: 0, capital_sum: 0,
            capital_percentage: 0, register_price: 0, register_sum_price: 0,
            register_status: nil, meeting_sn: '', change_type: nil, info: ''})
          ss.save
        end
      end
    else
      rs = RansomStock.where(id: id).first
      return if rs.nil?
      if rs.visible == true
        ss = StockStatic.where(ori_id: id, stock_type: StockStatic::STOCK_RANSOM).first
        ss = StockStatic.new(ori_id: id, stock_type: StockStatic::STOCK_RANSOM) if ss.nil?
        ##更新
        ss.attributes = ss.attributes.merge({register_status: nil, meeting_sn: '', change_type: nil, info: ''}).merge(
          rs.attributes.clone.slice(
            'user_id', 'company_id',
            'breo_stock_num', 'breo_stock_percentage',
            'stock_price', 'stock_sum_price', 'capital_sum',
            'capital_percentage', 'register_price', 'register_sum_price', 'info'))
        ss.save if ss.valid?
      else
        ss = StockStatic.where(ori_id: id, stock_type: StockStatic::STOCK_RANSOM).first
        unless ss.nil?
          ##重置
          ss.attributes = ss.attributes.merge({breo_stock_num: 0, breo_stock_percentage:0,
            stock_price: 0, stock_sum_price: 0, capital_sum: 0,
            capital_percentage: 0, register_price: 0, register_sum_price: 0,
            register_status: nil, meeting_sn: '', change_type: nil, info: ''})
          ss.save if ss.valid?
        end
      end
    end
  end
end