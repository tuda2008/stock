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

require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
