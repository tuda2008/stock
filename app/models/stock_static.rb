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

class StockStatic < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  has_one :buy_stock, -> { where(stock_type: STOCK_BUY) }, :class_name => "StockAccount", foreign_key: :ori_id
  has_one :ransom_stock, -> { where(stock_type: STOCK_RANSOM) }, :class_name => "RansomStock", foreign_key: :ori_id

  STOCK_BUY = 1
  STOCK_RANSOM = 2
  TYPES = [["认购", STOCK_BUY], ["赎回", STOCK_RANSOM]]

  validates :ori_id, :uniqueness => { :scope => :stock_type }
  validates :stock_type, inclusion: { in: [STOCK_BUY, STOCK_RANSOM], message: "必须是认购或赎回" } 

  scope :buy, -> { where(stock_type: STOCK_BUY) }
  scope :ransom, -> { where(stock_type: STOCK_RANSOM) }

  def self.sum_capital(company_id)
    StockStatic.select("stock_type, sum(capital_sum) as sum_capital_sum").where(company_id: company_id).group(:stock_type).order("stock_type")
  end

  def self.sum_breo_stock_num
    StockStatic.select("company_id, stock_type, sum(breo_stock_num) as sum_breo_stock_num").group(:company_id, :stock_type).order("stock_type")
  end

  def self.sum_breo_stock_num_by_company(company_id)
    StockStatic.select("stock_type, sum(breo_stock_num) as sum_breo_stock_num").where(company_id: company_id).group(:stock_type).order("stock_type")
  end

  def self.sum_breo_stock_num_by_user(user_id)
    StockStatic.select("company_id, stock_type, sum(breo_stock_num) as sum_breo_stock_num").where(user_id: user_id).group(:company_id, :stock_type).order("stock_type")
  end

  def self.sum_breo_stock_num_by_company_and_user(company_id, user_id)
    StockStatic.select("stock_type, sum(breo_stock_num) as sum_breo_stock_num").where(company_id: company_id, user_id: user_id).group(:stock_type).order("stock_type")
  end
end