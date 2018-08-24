# == Schema Information
#
# Table name: ransom_stocks
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :integer
#  stock_num             :bigint(8)
#  stock_price           :float(24)
#  stock_sum_price       :float(24)
#  breo_stock_num        :float(24)
#  breo_stock_percentage :float(24)
#  capital_sum           :float(24)
#  capital_percentage    :float(24)
#  register_price        :float(24)
#  register_sum_price    :float(24)
#  tax                   :float(24)
#  sum_price_after_tax   :float(24)
#  published_at          :date
#  tax_payed_at          :date
#  info                  :string(255)
#  visible               :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_ransom_stocks_on_company_id    (company_id)
#  index_ransom_stocks_on_user_company  (user_id,company_id)
#  index_ransom_stocks_on_user_id       (user_id)
#  index_ransom_stocks_on_visible       (visible)
#

class RansomStock < ApplicationRecord
  has_many :journals, :as => :journalized, :dependent => :destroy, :inverse_of => :journalized
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates :user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage, :capital_sum, :register_price, :register_sum_price, :tax, :published_at, :tax_payed_at, presence: true
  validates :breo_stock_num, :capital_sum, :register_sum_price, :stock_sum_price, numericality: {greater_than_or_equal_to: 100}
  validates :stock_price, :register_price, numericality: {greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1000}
  validates :breo_stock_percentage, numericality: {greater_than_or_equal_to: 0.0001, less_than_or_equal_to: 100}
  validates :tax, numericality: {greater_than_or_equal_to: 1}
  validate :breo_stock_num_numericality, :breo_stock_num_validate

  after_save :update_stock_ransom_history
  before_create :update_account_statics
  before_update :update_account_stock_statics
  
  def breo_stock_num_numericality
  	if (self.breo_stock_num.to_i)%100 > 0
  		errors.add :breo_stock_num, "必须是100的倍数"
  		false
  	else
  		true
  	end
  end

  def breo_stock_num_validate
    account_static = AccountStatic.where(user_id: self.user_id, company_id: self.company_id).first
    unless account_static.nil?
      if account_static.breo_stock_num < self.breo_stock_num.to_i
        errors.add :breo_stock_num, "赎回股数大于股东持有股数（#{account_static.breo_stock_num}）"
        return false
      end
      if account_static.breo_stock_percentage < self.breo_stock_percentage.to_f
        errors.add :breo_stock_percentage, "赎回股份占比大于股东持有股份占比（#{account_static.breo_stock_percentage}）"
        return false
      end
    else
      errors.add :company_id, "所选股东未持有该公司股票"
      return false
    end
    return true
  end

  def update_stock_ransom_history
  	if self.saved_changes?
  	  UpdateStockRansomHistoryWorker.perform_in(10.seconds, self.id, self.saved_changes.except("id", "created_at", "updated_at"))
    end
  end

  def sum_price_after_tax
    self.register_sum_price.to_f - self.tax.to_f
  end

  def update_account_statics
    if self.visible == true
      UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.breo_stock_num, -self.breo_stock_percentage, -self.stock_sum_price, -self.capital_sum)
    end
  end

  def update_account_stock_statics
    if self.visible_changed?
      if self.visible == true
        UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.breo_stock_num, -self.breo_stock_percentage, -self.stock_sum_price, -self.capital_sum)
      else
        stock_sum_price = 0
        breo_stock_num = 0
        breo_stock_percentage = 0
        capital_sum = 0
        if self.stock_sum_price_changed?
          stock_sum_price = self.stock_sum_price_was - self.stock_sum_price
        end
        if self.breo_stock_num_changed?
          breo_stock_num = self.breo_stock_num_was - self.breo_stock_num
        end
        if self.breo_stock_percentage_changed?
          breo_stock_percentage = self.breo_stock_percentage_was - self.breo_stock_percentage
        end
        if self.capital_sum_changed?
          capital_sum = self.capital_sum_was - self.capital_sum
        end
        UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, breo_stock_num, breo_stock_percentage, stock_sum_price, capital_sum)
      end
    else
      if self.visible == true
        stock_sum_price = 0
        breo_stock_num = 0
        breo_stock_percentage = 0
        capital_sum = 0
        if self.stock_sum_price_changed?
          stock_sum_price = self.stock_sum_price_was - self.stock_sum_price
        end
        if self.breo_stock_num_changed?
          breo_stock_num = self.breo_stock_num_was - self.breo_stock_num
        end
        if self.breo_stock_percentage_changed?
          breo_stock_percentage = self.breo_stock_percentage_was - self.breo_stock_percentage
        end
        if self.capital_sum_changed?
          capital_sum = self.capital_sum_was - self.capital_sum
        end
        UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, breo_stock_num, breo_stock_percentage, stock_sum_price, capital_sum)
      end
    end
  end

  def visible!
    self.visible = true
    self.save!
  end
  
  def unvisible!
    self.visible = false
    self.save!
  end

end