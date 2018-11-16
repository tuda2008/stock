# == Schema Information
#
# Table name: account_statics
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  breo_stock_num        :integer          default(0)
#  breo_stock_percentage :float(24)        default(0.0)
#  investment_sum_price  :float(24)        default(0.0)
#  capital_sum           :float(24)        default(0.0)
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

class AccountStatic < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates :user_id, :uniqueness => { :scope => :company_id }

  STOCK_PERCENTAGE = 1

  scope :ransom, -> { where("ransom_stock_num>0") }
  scope :no_ransom, -> { where("ransom_stock_num=0") }
  scope :big, -> { where("breo_stock_percentage>=?", STOCK_PERCENTAGE) }
  scope :small, -> { where("breo_stock_percentage<?", STOCK_PERCENTAGE) }
  scope :has_stock, -> { where("breo_stock_num>0") }
  scope :by_user, lambda { |user_id| where(user_id: user_id) }

  def self.stockholders_count(company_id)
    AccountStatic.group(:company_id).where("company_id=? and breo_stock_num>0", company_id).count
  end
end