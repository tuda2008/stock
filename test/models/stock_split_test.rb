# == Schema Information
#
# Table name: stock_splits
#
#  id             :bigint(8)        not null, primary key
#  company_id     :integer
#  stock_transfer :integer
#  stock_send     :integer
#  stock_bonus    :float(24)
#  info           :string(255)
#  published_at   :date
#  enabled        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_stock_splits_on_company_id  (company_id)
#  index_stock_splits_on_enabled     (enabled)
#

require 'test_helper'

class StockSplitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
