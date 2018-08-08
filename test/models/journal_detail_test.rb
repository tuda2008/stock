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

require 'test_helper'

class JournalDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
