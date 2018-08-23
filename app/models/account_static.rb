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

class AccountStatic < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates_uniqueness_of :user_id, scope: :company_id

  STOCK_PERCENTAGE = 1

  scope :ransom, -> { where("ransom_stock_num>0") }
  scope :no_ransom, -> { where("ransom_stock_num=0") }
  scope :big, -> { where("breo_stock_percentage>=?", STOCK_PERCENTAGE) }
  scope :small, -> { where("breo_stock_percentage<?", STOCK_PERCENTAGE) }

  def as_json(opts = {})
    {
      id: self.id,
      user: self.user.name || "",
      company: self.stock_company.name || "",
      breo_stock_num: self.breo_stock_num,
      stock_bonus: self.stock_bonus.to_f.round(2),
      ransom_stock_num: self.ransom_stock_num,
      ransom_sum_price: self.ransom_sum_price.to_f.round(2)
    }
  end
end
