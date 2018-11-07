# == Schema Information
#
# Table name: stock_splits
#
#  id             :bigint(8)        not null, primary key
#  company_id     :integer
#  stock_transfer :integer
#  stock_send     :integer
#  stock_bonus    :float(24)
#  info           :string(255)
#  published_at   :date
#  enabled        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_stock_splits_on_company_id  (company_id)
#  index_stock_splits_on_enabled     (enabled)
#

class StockSplit < ApplicationRecord
  has_many :journals, :as => :journalized, :dependent => :destroy, :inverse_of => :journalized
  belongs_to :stock_company, foreign_key: :company_id

  validates :company_id, :published_at, presence: true
  validates :info, length: { maximum: 250 }
  validates :stock_transfer, :stock_send, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validate :enabled_validate

  after_save :update_stock_split_history
  after_create :update_account_stock
  after_update :update_account_static

  def update_stock_split_history
  	if self.saved_changes?
  	  UpdateStockSplitHistoryWorker.perform_in(10.seconds, Current.admin_user.id, self.id, self.saved_changes.except("id", "created_at", "updated_at"))
    end
  end

  def update_account_stock
    if self.enabled == true
      UpdateAccountStaticWorker.perform_in(20.seconds, self.id)
    end
  end

  def update_account_static
    #todo refatcor
  end

  def enabled_validate
  	if self.enabled_was == true
  		errors.add :enabled, "确认派送后不能再编辑或删除"
  		false
  	else
  	  true
  	end
  end

  def disenable!
    self.enabled = false
    self.save!
  end
  
  def enable!
    self.enabled = true
    self.save!
  end
end