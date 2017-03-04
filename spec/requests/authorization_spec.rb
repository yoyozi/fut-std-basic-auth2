require 'rails_helper'

describe "Authorization:" do

    # Not logged in can see landing but not indexes posts and users
    # /

    describe "NOT logged in" do

        it 'can see landing page' do 
        visit root_url
                expect(page).to have_content 'Log In'
    
        end

    end

    # Posts

    describe "NOT logged in" do

        it 'cannot see posts index' do 
        visit posts_path
                expect(page).to have_content 'Log in required.'
    
        end

    end

    # Users

    describe "NOT logged in" do

        it 'cannot see users index' do 
        visit users_path
                expect(page).to have_content 'Log in required.'
    
        end

    end

    # Logged in 
    # Admin and pusers can see users index but not nusers
    # Users


    describe "ONLY Admin users logged in" do

        it 'can see Users index (Users)' do 
            user = create(:user, role: "admin")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit users_path
            expect(page).to have_content 'Listing Users'

        end

    end

    describe "Pusers logged in" do

        it 'can see users index' do 
            user = create(:user, role: "puser")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit users_path
            expect(page).to have_content 'Listing Users'

        end

    end

    describe "Nusers logged in" do

        it 'cannot see users index' do 
            user = create(:user, role: "nuser")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit users_path
            expect(page).to have_content 'Access denied.'

        end

    end

    # Logged in 
    # All can see own profile

    describe "Admin users logged in" do

        it 'can see and edit there own profile' do 
            user = create(:user, role: "admin")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            click_on user
            expect(page).to have_content 'Profile page'
            click_on "Edit"
            expect(page).to have_content 'Editing User'


        end

    end

    describe "Pusers logged in" do

        it 'can see and edit there own profile' do  
            user = create(:user, role: "puser")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            click_on user
            expect(page).to have_content 'Profile page'
            click_on "Edit"
            expect(page).to have_content 'Editing User'

        end

    end

    describe "Nusers logged in" do

        it 'can see and edit there own profile' do  
            user = create(:user, role: "nuser")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            click_on user
            expect(page).to have_content 'Profile page'
            click_on "Edit"
            expect(page).to have_content 'Editing User'

        end

    end


    # Logged in 
    # Admin can edit all profiles rest cannot edit other profiles

    describe "Admin users logged in" do

        it 'can edit all others profile' do 
            user = create(:user, role: "admin")
            other_user = create(:user, role: "admin")
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit edit_user_path(other_user)
            expect(page).to have_content 'Editing User'

        end

    end

    describe "Pusers logged in" do

        it 'can edit other profile'      do 
            user = create(:user, role: "puser")
            other_user = create(:user)
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit edit_user_path(other_user)
            expect(page).to have_content 'Editing User'

        end

    end

    describe "Nusers logged in" do

        it 'cannot edit other profile'      do 
            user = create(:user, role: "nuser")
            other_user = create(:user)
            log_in(user)
            expect(page).to have_content 'Logged in!'
            visit edit_user_path(other_user)
            expect(page).to have_content 'Access denied.'

        end

    end

    # Logged in 
    # Admin user can create an account only in adminrole Controller
    # Puser cannot and normal user cannot

    describe "Admin can create an account" do

        it "count should increase by one"    do
            user = create(:user, role: "admin")
            new_user = build(:user)

            log_in(user)
            expect(page).to have_content 'Logged in!'
            click_on "Roles"
            expect(page).to have_content 'Listing Users'
            click_link "New User"
            expect(page).to have_content 'First name'
            
            fill_in "First name", with: new_user.first_name
            fill_in "Last name", with: new_user.last_name
            fill_in "Email", with: new_user.email
            fill_in "Password", with: new_user.password
            fill_in "Password confirmation", with: new_user.password_confirmation
            click_button "Create User"
            ## Get this working
            #expect{}.to change(User, :count).by(1)
            expect(page).to have_content 'Profile page for ADMINROLE'
            expect(page).to have_content new_user.first_name
        end

    end

    describe "Puser cannot create an account" do

        it "count should not increase by one"    do
            user = create(:user, role: "puser")
            new_user = build(:user)

            log_in(user)
            expect(page).to have_content 'Logged in!'
            click_on "Users"
            expect(page).to have_content 'Listing Users'
            expect(page).not_to have_content "New User"
            visit new_adminrole_path
            expect(page).to have_content 'Access denied.'

        end

    end

    describe "Nuser cannot create an account" do

        it "count should not increase by one"    do
            user = create(:user, role: "nuser")
            new_user = build(:user)

            log_in(user)
            expect(page).to have_content 'Logged in!'
            expect(page).not_to have_content "Users"
            visit new_adminrole_path
            expect(page).to have_content 'Access denied.'  
            
        end

    end

    # Testing links available

    describe "Nuser cannot create an account" do

        it "count should not increase by one"    do
            user = create(:user, role: "nuser")
            new_user = build(:user)

            log_in(user)
            expect(page).to have_content 'Logged in!'
            expect(page).not_to have_content "Users"
            visit new_adminrole_path
            expect(page).to have_content 'Access denied.'  
            
        end

    end

 end