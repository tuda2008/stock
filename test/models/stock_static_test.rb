# == Schema Information
#
# Table name: stock_statics
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_type            :integer          default(1)
#  stock_price           :decimal(5, 2)
#  stock_sum_price       :decimal(20, 1)
#  breo_stock_num        :bigint(8)
#  breo_stock_percentage :decimal(8, 4)
#  capital_sum           :decimal(20, 1)
#  capital_percentage    :decimal(8, 4)
#  register_price        :decimal(5, 2)
#  register_sum_price    :decimal(20, 1)
#  register_status       :integer
#  meeting_sn            :string(60)       default("")
#  change_type           :integer
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  ori_id                :integer          not null
#
# Indexes
#
#  index_stock_statics_on_change_type      (change_type)
#  index_stock_statics_on_company_id       (company_id)
#  index_stock_statics_on_cs_type          (company_id,stock_type)
#  index_stock_statics_on_meeting_sn       (meeting_sn)
#  index_stock_statics_on_ori_type         (stock_type,ori_id)
#  index_stock_statics_on_register_status  (register_status)
#  index_stock_statics_on_stock_type       (stock_type)
#  index_stock_statics_on_ucs_type         (user_id,company_id,stock_type)
#  index_stock_statics_on_us_type          (user_id,stock_type)
#  index_stock_statics_on_user_id          (user_id)
#

require 'test_helper'

class StockStaticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
