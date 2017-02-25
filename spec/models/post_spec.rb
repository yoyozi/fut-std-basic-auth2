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

require 'rails_helper'
require 'ffaker'



RSpec.describe Post do


	describe Post do
  		it 'has a valid factory' do
    		expect(build(:post)).to be_valid
  		end
  	end

	context "validations" do 

 		it { should validate_presence_of(:title) }

 		it { should validate_presence_of(:content) }

 		it { should validate_presence_of(:user_id) }

 	end


	context "associations" do

  		it { should belong_to(:user) }

  	end

end
