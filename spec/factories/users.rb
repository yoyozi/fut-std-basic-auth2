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

FactoryGirl.define do 

	factory :user do

    sequence(:first_name)  { |n| "Tinker #{n}" }
    sequence(:last_name)  { |n| "Belle #{n}" }
		sequence(:email) { |n| "foo#{n}@pookbear.com" }
		password "secretive"
		password_confirmation "secretive"
    role 'nuser'

  end

end


