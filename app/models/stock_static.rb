# == Schema Information
#
# Table name: stock_statics
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_type            :integer          default(1)
#  stock_price           :float(24)
#  stock_sum_price       :float(24)
#  breo_stock_num        :float(24)
#  breo_stock_percentage :float(24)
#  capital_sum           :float(24)
#  capital_percentage    :float(24)
#  register_price        :float(24)
#  register_sum_price    :float(24)
#  register_status       :integer
#  meeting_sn            :string(60)       default("")
#  change_type           :integer
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_stock_statics_on_change_type      (change_type)
#  index_stock_statics_on_company_id       (company_id)
#  index_stock_statics_on_cs_type          (company_id,stock_type)
#  index_stock_statics_on_meeting_sn       (meeting_sn)
#  index_stock_statics_on_register_status  (register_status)
#  index_stock_statics_on_stock_type       (stock_type)
#  index_stock_statics_on_ucs_type         (user_id,company_id,stock_type)
#  index_stock_statics_on_us_type          (user_id,stock_type)
#  index_stock_statics_on_user_id          (user_id)
#

class StockStatic < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  STOCK_BUY = 1
  STOCK_RANSOM = 2

  scope :buy, -> { where(stock_type: STOCK_BUY) }
  scope :ransom, -> { where(stock_type: STOCK_RANSOM) }
end