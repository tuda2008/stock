# == Schema Information
#
# Table name: stock_split_histories
#
#  id             :integer          not null, primary key
#  stock_split_id :integer
#  user_id        :integer
#  company_id     :integer
#  stock_transfer :float(24)
#  stock_send     :float(24)
#  stock_bonus    :float(24)
#  origin_sum     :float(24)
#  new_sum        :float(24)
#  sum_bonus      :float(24)
#  info           :string(255)
#  published_at   :date
#  enabled        :boolean          default(FALSE)
#  created_at     :datetime         not null
#
# Indexes
#
#  index_stock_split_histories_on_user_company  (user_id,company_id)
#  index_stock_split_histories_on_user_id       (user_id)
#  index_stock_split_histories_on_user_split    (user_id,stock_split_id)
#

require 'test_helper'

class StockSplitHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
