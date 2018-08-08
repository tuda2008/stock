# == Schema Information
#
# Table name: stock_accounts
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  company_id   :bigint(8)
#  stock_sum    :bigint(8)
#  stock_price  :float(24)
#  visible      :boolean          default(FALSE)
#  level        :integer
#  published_at :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_stock_accounts_on_company_id         (company_id)
#  index_stock_accounts_on_user_company_info  (user_id,company_id)
#  index_stock_accounts_on_user_visible       (user_id,visible)
#  index_stock_accounts_on_visible            (visible)
#

require 'test_helper'

class StockAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
