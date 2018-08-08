# == Schema Information
#
# Table name: journal_details
#
#  id         :bigint(8)        not null, primary key
#  journal_id :integer          default(0), not null
#  prop_key   :string(30)       default(""), not null
#  old_value  :string(255)
#  value      :string(255)
#
# Indexes
#
#  journal_details_journal_id  (journal_id)
#

class JournalDetail < ApplicationRecord
  belongs_to :journal

  def value=(arg)
    write_attribute :value, normalize(arg)
  end

  def old_value=(arg)
    write_attribute :old_value, normalize(arg)
  end

  private

  def normalize(v)
    case v
    when true
      "1"
    when false
      "0"
    when Date
      v.strftime("%Y-%m-%d")
    else
      v
    end
  end
end