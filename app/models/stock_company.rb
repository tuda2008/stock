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
#  holders_stock_num       :float(24)        default(0.0)
#  holders_buy_sum_price   :float(24)        default(0.0)
#  ransom_stock_num        :float(24)        default(0.0)
#  ransom_sum_price        :float(24)        default(0.0)
#  holders_stock_sum_price :float(24)        default(0.0)
#  stock_price             :float(24)        default(0.0)
#  capital_sum             :float(24)        default(0.0)
#  stock_num               :float(24)        default(1.0)
#
# Indexes
#
#  index_stock_companies_on_name     (name) UNIQUE
#  index_stock_companies_on_visible  (visible)
#

class StockCompany < ApplicationRecord
  validates :name, :stock_num, presence: true
  validates :name, uniqueness: true
  validates :name, length: 3..50
  validates :description, :legal_representative, length: { maximum: 250 }

  scope :active, -> { where(visible: true) }
  scope :inactive, -> { where(visible: false) }

  def self.sum_stock_price
    sum = { sum_register_sum_price: 0, sum_capital_sum: 0 }
    StockAccount.sum_stock_price.each do |stock|
      sum[:sum_register_sum_price] += stock.sum_register_sum_price.to_f
      sum[:sum_capital_sum] += stock.sum_capital_sum.to_f
      sum["#{stock.company_id}"] = { sum_register_sum_price: stock.sum_register_sum_price.to_f, sum_capital_sum: stock.sum_capital_sum.to_f }
    end
    sum
  end

  def block!
    self.visible = false
    self.save!
  end
  
  def unblock!
    self.visible = true
    self.save!
  end
end
