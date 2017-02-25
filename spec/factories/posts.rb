# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'ffaker'

FactoryGirl.define do

  factory :post do

  	user_id 1
    title  { FFaker::Name.name }
    content { FFaker::Lorem.paragraph}
    #current_user true

  end
end


# require 'faker'

#FactoryGirl.define do
#  factory :post do |f|
#  	f.user nil
#   f.title    	{ Faker::Title.title }
#   f.content        { Faker::Content.content}
#  end
#end
