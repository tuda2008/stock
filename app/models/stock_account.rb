# == Schema Information
#
# Table name: stock_accounts
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_sum             :bigint(8)
#  stock_price           :float(24)
#  stock_sum_price       :float(24)
#  breo_stock_num        :float(24)
#  breo_stock_percentage :float(24)
#  capital_sum           :float(24)
#  capital_percentage    :float(24)
#  register_price        :float(24)
#  register_sum_price    :float(24)
#  register_status       :integer
#  register_at           :date
#  investment_sum_price  :float(24)
#  investment_at         :date
#  transfered_at         :date
#  change_type           :integer
#  visible               :boolean          default(FALSE)
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_stock_accounts_on_change_type        (change_type)
#  index_stock_accounts_on_company_id         (company_id)
#  index_stock_accounts_on_user_company_info  (user_id,company_id)
#  index_stock_accounts_on_user_visible       (user_id,visible)
#  index_stock_accounts_on_visible            (visible)
#

class StockAccount < ApplicationRecord
  # 办结状态
  HANDLED   = 1 # 已办结
  HANDING   = 2 # 办理中
  NO_RECORD = 3 # 不备案

  STATUSES = [["已办结", HANDLED], ["办理中", HANDING], ["不备案", NO_RECORD]]
  STATUSES_NAME = {"#{HANDLED}": "已办结", "#{HANDING}": "办理中", "#{NO_RECORD}": "不备案"}

  # 变动类别
  INSPIRE      = 1 #股权激励
  TRANSFER     = 2 #股东间股权转让
  BONUS        = 3 #股票股利
  PRIVATE_JOIN = 4 #私募入股
  WORK_JUMP    = 5 #离职退股
  PRIVATE_OUT  = 6 #私募退股

  TYPES = [["股权激励", INSPIRE], ["股东间股权转让", TRANSFER], ["股票股利", BONUS], ["私募入股", PRIVATE_JOIN], ["离职退股", WORK_JUMP], ["私募退股", PRIVATE_OUT]]
  TYPES_NAME = {"#{INSPIRE}": "股权激励", "#{TRANSFER}": "股东间股权转让", "#{BONUS}": "股票股利", "#{PRIVATE_JOIN}": "私募入股", "#{WORK_JUMP}": "离职退股", "#{PRIVATE_OUT}": "私募退股"}

  has_many :journals, :as => :journalized, :dependent => :destroy, :inverse_of => :journalized
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates :user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage, :investment_at, presence: true
  validates :breo_stock_num, :capital_sum, numericality: {greater_than_or_equal_to: 100}
  validates :stock_price, :register_price, numericality: {greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1000}
  validates :breo_stock_percentage, numericality: {greater_than_or_equal_to: 0.0001, less_than_or_equal_to: 100}
  validates :stock_sum_price, :investment_sum_price, :register_sum_price, numericality: {greater_than_or_equal_to: 1000}
  validate :stock_sum_numericality, :visible_validate 

  after_create :cteate_stock_account, :update_stock_accounts_history
  before_update :update_stock_accounts
  after_update :update_stock_accounts_history

  scope :companies, lambda { |user_id| where(user_id: user_id).includes(:stock_company) }
  scope :active, -> { where(visible: true) }

  def stock_sum_numericality
  	if (self.breo_stock_num.to_i)%100 > 0
  		errors.add :breo_stock_num, "必须是100的倍数"
  		false
    elsif (self.capital_sum.to_i)%100 > 0
      errors.add :capital_sum, "必须是100的倍数"
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
        CreateAccountStaticWorker.perform_in(5.seconds, self.id)
      else
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.breo_stock_num_was, -self.breo_stock_percentage_was, -self.stock_sum_price_was, -self.capital_sum_was)
      end
    else
      if (self.visible == true)
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.user_id, self.company_id, self.breo_stock_num - self.breo_stock_num_was, self.breo_stock_percentage - self.breo_stock_percentage_was, 
          self.stock_sum_price - self.stock_sum_price_was, self.capital_sum - self.capital_sum_was)
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
  		ss = StockSplit.where(company_id: self.company_id, enabled: true).where("published_at > ?", self.investment_at).first
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

  def self.sum_stock_price
    StockAccount.active.select("company_id, sum(register_sum_price) as sum_register_sum_price, sum(capital_sum) as sum_capital_sum").group(:company_id)
  end

end