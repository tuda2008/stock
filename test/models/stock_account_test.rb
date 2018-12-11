# == Schema Information
#
# Table name: stock_accounts
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_sum             :bigint(8)
#  stock_price           :decimal(5, 2)
#  stock_sum_price       :decimal(20, 1)
#  breo_stock_num        :bigint(8)
#  breo_stock_percentage :decimal(8, 4)
#  capital_sum           :decimal(20, 1)
#  capital_percentage    :decimal(8, 4)
#  register_price        :decimal(5, 2)
#  register_sum_price    :decimal(20, 1)
#  register_status       :integer
#  register_at           :date
#  investment_sum_price  :decimal(20, 1)
#  investment_at         :date
#  transfered_at         :date
#  change_type           :integer
#  visible               :boolean          default(FALSE)
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  meeting_sn            :string(60)       default("")
#  investment_price      :decimal(5, 2)
#  ransom_at             :datetime
#  archived_at           :datetime
#
# Indexes
#
#  index_stock_accounts_on_change_type        (change_type)
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
