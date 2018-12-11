# == Schema Information
#
# Table name: stock_companies
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  legal_representative    :string(255)
#  published_at            :date
#  visible                 :boolean          default(TRUE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  stockholders_num        :integer          default(0)
#  holders_stock_num       :decimal(20, 1)   default(0.0)
#  holders_buy_sum_price   :decimal(20, 1)   default(0.0)
#  ransom_stock_num        :decimal(20, 1)   default(0.0)
#  ransom_sum_price        :decimal(20, 1)   default(0.0)
#  holders_stock_sum_price :decimal(20, 1)   default(0.0)
#  stock_price             :decimal(5, 2)    default(0.0)
#  capital_sum             :decimal(20, 1)   default(0.0)
#  stock_num               :decimal(20, 1)   default(1.0)
#  breo_stock_num          :decimal(20, 1)
#
# Indexes
#
#  index_stock_companies_on_name     (name) UNIQUE
#  index_stock_companies_on_visible  (visible)
#

require 'test_helper'

class StockCompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
