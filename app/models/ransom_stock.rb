# == Schema Information
#
# Table name: ransom_stocks
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  company_id   :integer
#  stock_num    :bigint(8)
#  stock_price  :float(24)
#  info         :string(255)
#  published_at :date
#  visible      :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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

  validates :user_id, :company_id, :stock_num, :stock_price, :published_at, presence: true
  validates :stock_num, numericality: {greater_than_or_equal_to: 100}
  validates :stock_price, numericality: {min: 0.1, max: 1000}
  validate :stock_num_numericality, :stock_num_validate

  after_save :update_stock_ransom_history
  before_create :update_account_statics
  before_update :update_account_stock_statics
  
  def stock_num_numericality
  	if (self.stock_num.to_i)%100 > 0
  		errors.add :stock_sum, "必须是100的倍数"
  		false
  	else
  		true
  	end
  end

  def stock_num_validate
    account_static = AccountStatic.where(user_id: self.user_id, company_id: self.company_id).first
    unless account_static.nil?
      if account_static.stock_sum < self.stock_num.to_i
        errors.add :stock_num, "赎回股数大于股东持有股数（#{account_static.stock_sum}）"
      end
    else
      errors.add :company_id, "所选股东未持有该公司股票"
      false
    end
  end

  def update_stock_ransom_history
  	if self.saved_changes?
  	  UpdateStockRansomHistoryWorker.perform_in(10.seconds, self.id, self.saved_changes.except("id", "created_at", "updated_at"))
    end
  end

  def update_account_statics
    if self.visible == true
      UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.stock_num, -(self.stock_num*self.stock_price))
    end
  end

  def update_account_stock_statics
    if self.visible_changed?
      if self.visible == true
        UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.stock_num, -(self.stock_num*self.stock_price))
      else
        stock_sum_price = 0
        if self.stock_num_changed?
          stock_sum_price = self.stock_num_was*self.stock_price_was - self.stock_num*self.stock_price
        else
          stock_sum_price = self.stock_num*self.stock_price_was - self.stock_num*self.stock_price
        end
        UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, self.stock_num_was, stock_sum_price)
      end
    else
      if self.visible == true
        if self.stock_num_changed?
          stock_sum_price = 0
          if self.stock_price_changed?
            stock_sum_price = self.stock_num_was*self.stock_price_was - self.stock_num*self.stock_price
          else
            stock_sum_price = self.stock_num_was*self.stock_price - self.stock_num*self.stock_price
          end
          UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, self.stock_num_was - self.stock_num, stock_sum_price)
        elsif self.stock_price_changed?
          stock_sum_price = 0
          if self.stock_num_changed?
            stock_sum_price = self.stock_num_was*self.stock_price_was - self.stock_num*self.stock_price
          else
            stock_sum_price = self.stock_num*self.stock_price_was - self.stock_num*self.stock_price
          end
          UpdateAccountStockSumWorker.perform_in(5.seconds, self.user_id, self.company_id, self.stock_num_was - self.stock_num, stock_sum_price)
        end
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