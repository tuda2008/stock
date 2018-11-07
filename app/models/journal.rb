# == Schema Information
#
# Table name: journals
#
#  id               :bigint(8)        not null, primary key
#  user_id          :integer          default(0), not null
#  journalized_id   :integer          default(0), not null
#  journalized_type :string(30)       default(""), not null
#  created_at       :datetime         not null
#
# Indexes
#
#  index_journals_on_created_at      (created_at)
#  index_journals_on_journalized_id  (journalized_id)
#  index_journals_on_user_id         (user_id)
#  journals_journalized_id           (journalized_id,journalized_type)
#  journals_journalized_type         (journalized_type)
#

class Journal < ApplicationRecord
  belongs_to :journalized, :polymorphic => true
  belongs_to :admin_user, :class_name => "AdminUser", foreign_key: :user_id
  has_many :details, :class_name => "JournalDetail", :dependent => :delete_all, :inverse_of => :journal

  scope :default, -> { order('created_at desc') }
  scope :stock_account, -> { where(journalized_type: "StockAccount") }
  scope :stock_split, -> { where(journalized_type: "StockSplit") }
  scope :stock_ransom, -> { where(journalized_type: "RansomStock") }

end
