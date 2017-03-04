# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role            :integer          default("0"), not null
#

class User < ActiveRecord::Base

  has_secure_password

  enum role: [:nuser, :puser, :admin]

  has_many :posts, dependent: :destroy
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, on: :create, uniqueness: true,format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, presence: true, on: :create, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create
  validates :role, presence: true

  def to_s
    "#{first_name} #{last_name}"
  end

end
