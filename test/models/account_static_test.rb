# == Schema Information
#
# Table name: account_statics
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  breo_stock_num        :integer          default(0)
#  breo_stock_percentage :float(24)        default(0.0)
#  stock_sum_price       :float(24)        default(0.0)
#  stock_bonus           :float(24)        default(0.0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  ransom_stock_num      :integer          default(0)
#  ransom_sum_price      :float(24)        default(0.0)
#
# Indexes
#
#  index_account_statics_on_company_id    (company_id)
#  index_account_statics_on_user_company  (user_id,company_id)
#  index_account_statics_on_user_id       (user_id)
#

require 'test_helper'

class AccountStaticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
