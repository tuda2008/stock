# == Schema Information
#
# Table name: stock_accounts
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_sum             :bigint(8)
#  stock_price           :float(24)
#  stock_sum_price       :float(24)
#  breo_stock_num        :float(24)
#  breo_stock_percentage :float(24)
#  capital_sum           :float(24)
#  capital_percentage    :float(24)
#  register_price        :float(24)
#  register_sum_price    :float(24)
#  register_status       :integer
#  register_at           :date
#  investment_sum_price  :float(24)
#  investment_at         :date
#  transfered_at         :date
#  change_type           :integer
#  visible               :boolean          default(FALSE)
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  meeting_sn            :string(30)       default("")
#  investment_price      :float(24)
#  ransom_at             :datetime
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
