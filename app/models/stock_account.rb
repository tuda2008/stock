# == Schema Information
#
# Table name: stock_accounts
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  company_id   :bigint(8)
#  stock_sum    :bigint(8)
#  stock_price  :float(24)
#  visible      :boolean          default(FALSE)
#  level        :integer
#  published_at :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_stock_accounts_on_company_id         (company_id)
#  index_stock_accounts_on_user_company_info  (user_id,company_id)
#  index_stock_accounts_on_user_visible       (user_id,visible)
#  index_stock_accounts_on_visible            (visible)
#

class StockAccount < ApplicationRecord
  has_many :journals, :as => :journalized, :dependent => :destroy, :inverse_of => :journalized
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates :user_id, :company_id, :stock_sum, :stock_price, :published_at, presence: true
  #validates :level, numericality: {greater_than: 0, less_than_or_equal_to: 10}
  validates :stock_sum, numericality: {greater_than_or_equal_to: 100}
  validates :stock_price, numericality: {min: 0.1, max: 1000}
  validate :stock_sum_numericality, :visible_validate 

  after_create :cteate_stock_account, :update_stock_accounts_history
  before_update :update_stock_accounts
  after_update :update_stock_accounts_history

  scope :companies, lambda { |user_id| where(user_id: user_id).includes(:stock_company) }

  def stock_sum_numericality
  	if (self.stock_sum.to_i)%100 > 0
  		errors.add :stock_sum, "必须是100的倍数"
  		false
  	else
  		true
  	end
  end

  def cteate_stock_account
    if self.visible == true
      CreateAccountStaticWorker.perform_in(5.seconds, self.id)
    end
  end

  def update_stock_accounts
    if self.visible_changed?
      if self.visible == true
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.id, self.stock_sum)
      else
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.id, -self.stock_sum_was)
      end
    else
      if (self.visible == true && self.stock_sum_changed?)
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.id, self.stock_sum - self.stock_sum_was)
      end
    end
  end

  def update_stock_accounts_history
    if self.saved_changes?
      UpdateStockAccountHistoryWorker.perform_in(15.seconds, self.id, self.saved_changes.except("id", "created_at", "updated_at"))
    end
  end

  def visible_validate
  	if self.visible_was == true
      if self.visible == false && (self.stock_sum_changed? || self.stock_price_changed?)
        errors.add :stock_sum, "认购有效变为无效时，不能变更股票数量与单价"
        false
      end
  		ss = StockSplit.where(company_id: self.company_id, enabled: true).where("published_at > ?", self.published_at).first
  		if ss
  		  	errors.add :visible, "派送股后不能再编辑或删除"
  		  	false
  		else
  		  	true
  		end
  	else
  	    true
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
