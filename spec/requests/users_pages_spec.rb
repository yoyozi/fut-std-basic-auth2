#require 'rails_helper'
#
#
#describe "User pages", type: :feature do
#
#  subject { page }
#
#  describe "profile page show action" do
#
#    user = FactoryGirl.create(:user)
#    log_in user
#    
#    before { visit user_path(user) }
#    it { should have_content('Profile page') }
#
#  end
#
#  describe "edit" do
#
#    user = FactoryGirl.create(:user)
#    log_in user
#
#    before { visit edit_user_path(user) }
#
#    describe "page" do
#      it { should have_content("Update your profile") }
#    end
#
#    describe "with invalid information" do
#      before { click_button "Save changes" }
#
#      it { should have_content('Editing User') }
#    end
#
#  end
#
#  describe "signup page" do
#
#    before { visit signup_path }
#    it { should have_selector('h1',    text: 'New User') }
#    it { should have_field('First name') }
#    it { should have_field('Last name') }
#    it { should have_field('Password') }
#    it { should have_field('Password confirmation') }
#    it { should have_button('Create User') }
#    
#  end
#
#end#