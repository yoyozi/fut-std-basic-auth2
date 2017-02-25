require 'rails_helper'

describe "Authorization:" do

    describe "users logged in" do

        it 'cannot see users index' do 
            user = FactoryGirl.create(:user)

            visit root_url
            click_on "Log In"
            fill_in 'Email', with:  user.email
            fill_in 'Password', with: user.password
            click_button "Submit"
            expect(page).to have_content 'Logged in!'
            visit users_path
            expect(page).to have_content 'Not authorized!'

        end

    end

    describe "users logged in " do

        it 'can edit there own profile' do 
            user = FactoryGirl.create(:user)

            visit root_url
            click_on "Log In"
            fill_in 'Email', with:  user.email
            fill_in 'Password', with: user.password
            click_button "Submit"
            expect(page).to have_content 'Logged in!'
            click_on user
            expect(page).to have_content 'Editing User'

        end

    end

    describe "users logged in " do

        it 'can ONLY edit there own profile' do 
            user = FactoryGirl.create(:user)
            otheruser = FactoryGirl.create(:user)

            visit root_url
            click_on "Log In"
            fill_in 'Email', with:  user.email
            fill_in 'Password', with: user.password
            click_button "Submit"
            expect(page).to have_content 'Logged in!'
            visit edit_user_path(otheruser)
            expect(page).to have_content 'Not authorized!'

        end

    end

    describe "users NOT logged in " do

        it 'cannot see a profile' do 
            user = FactoryGirl.create(:user)
            otheruser = FactoryGirl.create(:user)

            visit root_url
            visit edit_user_path(otheruser)
            expect(page).to have_content 'Not authorized!'

        end

    end

    describe "Admin users logged in " do

        it 'can edit any profile' do 
            user = FactoryGirl.create(:admin)
            otheruser = FactoryGirl.create(:user)

            visit root_url
            click_on "Log In"
            fill_in 'Email', with:  user.email
            fill_in 'Password', with: user.password
            click_button "Submit"
            expect(page).to have_content 'Logged in!'
            visit edit_user_path(otheruser)
            expect(page).to have_content 'Editing User'

        end

    end


end
#
#    it 'Disallows blank entries to login' do 
#        user = FactoryGirl.create(:user)
#
#        visit root_url
#        click_on "Log In"
#        fill_in 'Email', with:  ' '
#        fill_in 'Password', with: ' '
#        click_button "Submit"
#        expect(page).to have_content 'Log In'
#    end
#
#     it 'Disallows valid email but invalid password users to login' do 
#        user = FactoryGirl.create(:user)
#
#        visit root_url
#        click_on "Log In"
#        fill_in 'Email', with:  user.email
#        fill_in 'Password', with: 'invalidpassword'
#        click_button "Submit"
#        expect(page).to have_content 'Invalid'
#    end
#
#     it 'Disallows valid email but invalid password users to login' do 
#        user = FactoryGirl.create(:user)
#
#        visit root_url
#        click_on "Log In"
#        fill_in 'Email', with:  user.email
#        fill_in 'Password', with: 'invalidpassword'
#        click_button "Submit"
#        expect(page).to have_content('Invalid') 
#    end
#
#     it 'Disallows invalid email but valid password users to login' do  
#        user = FactoryGirl.create(:user)
#        
#        visit root_url
#        click_on "Log In"
#        fill_in 'Password', with: user.password
#        fill_in 'Email', with:  'aninvalid@email.com'
#        click_button "Submit"
#        expect(page).to have_content('Invalid')
#    end
#
#     it 'Disallows invalid email but valid password users to login' do  
#        user = FactoryGirl.create(:user)
#        
#        visit root_url
#        click_on "Log In"
#        fill_in 'Password', with: user.password
#        fill_in 'Email', with:  'aninvalid@email.com'
#        click_button "Submit"
#        expect(page).to have_content 'Invalid'
#    end
#
#    it 'Allows registered users to login and logout' do 
#        user = FactoryGirl.create(:user)
#
#        visit root_url
#        click_on "Log In"
#        fill_in 'Email', with:  user.email
#        fill_in 'Password', with: user.password
#        click_button "Submit"
#        click_link "Log Out"
#        expect(page).to have_content 'Log In'
#    end
#
#    it 'Allows registered users to login and logout' do 
#        user = FactoryGirl.create(:user)
#
#        visit root_url
#        click_on "Log In"
#        fill_in 'Email', with:  user.email
#        fill_in 'Password', with: user.password
#        click_button "Submit"
#        click_link "Log Out"
#        expect(page).to have_content 'Logged out!'
#    end
#
#
#
#
#
#
#
#
#
#
#
#require 'rails_helper'
#
#RSpec.describe "AuthorizationHelper" do
#
#    describe "as non-admin user" do
#        #admin = FactoryGirl.create(:admin)
#        user = FactoryGirl.create(:user)
#        log_in user
#
#        it "submitting a DELETE request to the Users#destroy action" do
#            delete user_path(admin)
#
#            #specify{ response.should redirect_to(root_path) }
#            #specify{ response.should_not be_success }
#        end
#    end
#
#    
#
#    it 'disallows users that are not logged in to edit profile' do 
#     	user = FactoryGirl.create(:user)
#
# 		visit edit_user_path(user)
# 		expect(page).to have_content ('Not authorized!')
#
#	end
#
#    #it 'allows users that are logged in to edit profile' do 
#    # 	user = FactoryGirl.create(:user)
#    #  	log_in user
# 	#	visit edit_user_path(user)
##
# 	#	fill_in "First name",             with: "wnew_firstname"
# 	#	fill_in "Last name",             with: "wnew_lastname"
#    #    fill_in "Email",            with: "new@emwail.com"
#    #    fill_in "Password",         with: "uswer.password"
#    #    fill_in "Password confirmation", with: "uswer.password"
# 	#	click_button "Update User"
# 	#	expect(page).to have_content 'wnew_firstname'
##
#	#end
#
#	#it 'disallows users that are logged in to edit other users profile' do 
#   # 	user = FactoryGirl.create(:user)
#   # 	log_in user
#   # 	otheruser = FactoryGirl.create(:user)
# 	#	visit edit_user_path(otheruser)
# 	#	expect(page).to have_content ('Not authorized!')
##
#	#end
#
# 
#
#end
#
#
#