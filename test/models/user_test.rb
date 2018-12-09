# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  mobile                 :string(255)
#  name                   :string(255)
#  bank_name              :string(255)
#  card                   :string(255)
#  cert_id                :string(255)
#  cert_address           :string(255)
#  department             :string(255)
#  user_cate              :integer          default(1), not null
#  user_type              :integer          default(1), not null
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_cert_id                  (cert_id) UNIQUE
#  index_users_on_department               (department)
#  index_users_on_email                    (email)
#  index_users_on_mobile                   (mobile)
#  index_users_on_name                     (name)
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#  index_users_on_unlock_token             (unlock_token) UNIQUE
#  index_users_on_user_cate                (user_cate)
#  index_users_on_user_cate_and_user_type  (user_cate,user_type)
#  index_users_on_user_type                (user_type)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
