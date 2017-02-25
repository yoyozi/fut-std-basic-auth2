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
#  admin           :boolean
#

FactoryGirl.define do 
	factory :user do
    sequence(:first_name)  { |n| "Tinker #{n}" }
    sequence(:last_name)  { |n| "Belle #{n}" }
		sequence(:email) { |n| "foo#{n}@pookbear.com" }
		password "secretive"
		password_confirmation "secretive"

# With the below we can now use FactoryGirl.create(:admin) to create an administrative user in our tests.

    	factory :admin do
      		admin true
   	 	end
  	end
end


