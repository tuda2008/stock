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
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_mobile                   (mobile) UNIQUE
#  index_users_on_name                     (name)
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#  index_users_on_unlock_token             (unlock_token) UNIQUE
#  index_users_on_user_cate                (user_cate)
#  index_users_on_user_cate_and_user_type  (user_cate,user_type)
#  index_users_on_user_type                (user_type)
#

class User < ApplicationRecord
  # 定义股东类别
  EMPLOYEE = 1 # 员工
  EXTERNAL = 2 # 外部

  # 定义股东性质
  NATURAL = 1 # 自然人
  LEGAL = 2   # 法人股东
  FOREIGN = 3 # 外资

  CATES = [["员工", EMPLOYEE], ["外部", EXTERNAL]]
  CATES_NAME = {"1": "员工", "2": "外部"}
  TYPE = [["自然人", NATURAL], ["法人股东", LEGAL], ["外资", FOREIGN]]
  TYPE_NAME = {"1": "自然人", "2": "法人股东", "3": "外资"}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:mobile]

  validates :mobile, :email, :name, :card, :bank_name, :cert_id, :cert_address, :user_cate, :user_type, presence: true
  validates_uniqueness_of :mobile, :name, :email, :card, :cert_id

  scope :active, -> { where("locked_at is null") }
  scope :inactive, -> { where("locked_at is not null") }

  def lock!
    self.locked_at = Time.now.utc
    save!
  end

  def unlock!
    self.locked_at = nil
    save
  end

  protected
  	def password_required?
  	  false
  	end

end