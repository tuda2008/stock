# == Schema Information
#
# Table name: stock_accounts
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :integer
#  company_id            :bigint(8)
#  stock_sum             :bigint(8)
#  stock_price           :decimal(5, 2)
#  stock_sum_price       :decimal(20, 1)
#  breo_stock_num        :bigint(8)
#  breo_stock_percentage :decimal(8, 4)
#  capital_sum           :decimal(20, 1)
#  capital_percentage    :decimal(8, 4)
#  register_price        :decimal(5, 2)
#  register_sum_price    :decimal(20, 1)
#  register_status       :integer
#  register_at           :date
#  investment_sum_price  :decimal(20, 1)
#  investment_at         :date
#  transfered_at         :date
#  change_type           :integer
#  visible               :boolean          default(FALSE)
#  info                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  meeting_sn            :string(60)       default("")
#  investment_price      :decimal(5, 2)
#  ransom_at             :datetime
#  archived_at           :datetime
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
  #extend Enumerize
  # 办结状态
  HANDLED   = 1 # 已办结
  HANDING   = 2 # 办理中
  NO_RECORD = 3 # 不备案

  #enumerize :statuses, in: {:handled => 1, :handing => 2, :no_record => 3}

  STATUSES = [["已办结", HANDLED], ["办理中", HANDING], ["不备案", NO_RECORD]]
  STATUSES_NAME = {"#{HANDLED}": "已办结", "#{HANDING}": "办理中", "#{NO_RECORD}": "不备案"}

  # 变动类别
  INSPIRE      = 1 #股权激励
  TRANSFER     = 2 #股东间股权转让
  BONUS        = 3 #股票股利
  PRIVATE_JOIN = 4 #私募入股
  WORK_JUMP    = 5 #离职退股
  PRIVATE_OUT  = 6 #私募退股
  RATIO_NO_CHNAGE  = 7 #同比例稀释

  TYPES = [["股权激励", INSPIRE], ["股东间股权转让", TRANSFER], ["股票股利", BONUS], ["私募入股", PRIVATE_JOIN], ["离职退股", WORK_JUMP], ["私募退股", PRIVATE_OUT], ["同比例稀释", RATIO_NO_CHNAGE]]
  TYPES_NAME = {"#{INSPIRE}": "股权激励", "#{TRANSFER}": "股东间股权转让", "#{BONUS}": "股票股利", "#{PRIVATE_JOIN}": "私募入股", "#{WORK_JUMP}": "离职退股", "#{PRIVATE_OUT}": "私募退股", "#{RATIO_NO_CHNAGE}": "同比例稀释"}

  has_many :journals, :as => :journalized, :dependent => :destroy, :inverse_of => :journalized
  belongs_to :user, foreign_key: :user_id
  belongs_to :stock_company, foreign_key: :company_id

  validates :user_id, :company_id, :stock_price, :stock_sum_price, :breo_stock_num, :breo_stock_percentage, presence: true
  validates :breo_stock_num, numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validates :capital_sum, numericality: {greater_than_or_equal_to: 0}
  validates :stock_price, :register_price, numericality: {greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1000}
  validates :investment_price, numericality: {allow_blank: true, greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1000}
  validates :breo_stock_percentage, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :stock_sum_price, :register_sum_price, numericality: {greater_than_or_equal_to: 1000}
  validates :investment_sum_price, numericality: {allow_blank: true, greater_than_or_equal_to: 1000}
  validate  :visible_validate

  validates_date :register_at, allow_blank: true, :on_or_after => :investment_at, :on_or_after_message => "不能在 合约入股时间 之前"
  validates_date :investment_at, :transfered_at, allow_blank: true
  validates_date :ransom_at, allow_blank: true, :after => :register_at, :after_message => "必须在 工商系统办结时间 之后"

  after_create :create_stock_account, :update_stock_accounts_history
  before_update :update_stock_accounts
  after_update :update_stock_accounts_history

  scope :companies, lambda { |user_id| where(user_id: user_id).includes(:stock_company) }
  scope :active, -> { where(visible: true) }
  scope :inactive, -> { where(visible: false) }

  def create_stock_account
    if self.visible == true
      UpdateStockStaticWorker.perform_in(1.seconds, self.id)
      CreateAccountStaticWorker.perform_in(3.seconds, self.id)
      UpdateStockCompanyWorker.perform_in(5.seconds, self.user_id, self.company_id, self.capital_sum, true, true)
    end
  end

  def update_stock_accounts
    UpdateStockStaticWorker.perform_in(1.seconds, self.id) if self.visible == true
    if self.visible_changed?
      if self.visible == true
        #self.archived_at = Time.now.utc
        CreateAccountStaticWorker.perform_in(3.seconds, self.id)
        UpdateStockCompanyWorker.perform_in(5.seconds, self.user_id, self.company_id, self.capital_sum, true, true)
      else
        self.archived_at = nil
        UpdateStockCompanyWorker.perform_in(3.seconds, self.user_id, self.company_id, -self.capital_sum_was, true, false)
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.user_id, self.company_id, -self.breo_stock_num_was, -self.breo_stock_percentage_was, -self.stock_sum_price_was, -self.capital_sum_was)
      end
    else
      if (self.visible == true)
        UpdateStockCompanyWorker.perform_in(3.seconds, self.user_id, self.company_id, self.capital_sum - self.capital_sum_was, true, false)
        UpdateAccountStaticSumWorker.perform_in(5.seconds, self.user_id, self.company_id, self.breo_stock_num - self.breo_stock_num_was, self.breo_stock_percentage - self.breo_stock_percentage_was, 
          self.stock_sum_price - self.stock_sum_price_was, self.capital_sum - self.capital_sum_was)
      end
    end
  end

  def update_stock_accounts_history
    if self.saved_changes?
      UpdateStockAccountHistoryWorker.perform_in(10.seconds, Current.admin_user.id, self.id, self.saved_changes.except("id", "created_at", "updated_at"))
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

  def archive!
    self.archived_at = Time.now.utc
    self.save!
  end

  def unarchive!
    self.archived_at = nil
    self.save!
  end

  def visible!
    #self.archived_at = Time.now.utc
    self.visible = true
    self.save!
  end
  
  def unvisible!
    self.archived_at = nil
    self.visible = false
    self.save!
  end

  def self.sum_stock_price
    StockAccount.active.select("company_id, sum(register_sum_price) as sum_register_sum_price, sum(capital_sum) as sum_capital_sum").group(:company_id)
  end

end
