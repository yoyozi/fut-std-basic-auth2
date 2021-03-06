require 'rails_helper'

describe "Register a new user", :type => :feature do

  subject { page }

  describe "signup page tesiting for new sessions action and view" do

    before { visit signup_path }
    it { should have_selector('h1',    text: 'New User') }
    it { should have_link('Home', href: '/') }
    it { should_not have_link('Log out', href: '/logout') }
    it { should have_link('Log In', href: '/login') }


  end

end

describe "SignInProcess", :type => :feature do

  it 'Allows registered users to login' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_button "Submit"
    expect(page).to have_content 'Logged in!'
  end

  it 'Disallows blank entries to login' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  ' '
    fill_in 'Password', with: ' '
    click_button "Submit"
    expect(page).to have_content 'Log In'
  end

   it 'Disallows valid email but invalid password users to login' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: 'invalidpassword'
    click_button "Submit"
    expect(page).to have_content 'Invalid'
  end

   it 'Disallows valid email but invalid password users to login' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: 'invalidpassword'
    click_button "Submit"
    expect(page).to have_content('Invalid') 
  end

     it 'Disallows invalid email but valid password users to login' do  
      user = FactoryGirl.create(:user)
      
    visit root_url
    click_on "Log In"
    fill_in 'Password', with: user.password
    fill_in 'Email', with:  'aninvalid@email.com'
    click_button "Submit"
    expect(page).to have_content('Invalid')
  end

     it 'Disallows invalid email but valid password users to login' do  
      user = FactoryGirl.create(:user)
      
    visit root_url
    click_on "Log In"
    fill_in 'Password', with: user.password
    fill_in 'Email', with:  'aninvalid@email.com'
    click_button "Submit"
    expect(page).to have_content 'Invalid'
  end

  it 'Allows registered users to login and logout' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_button "Submit"
    click_link "Log Out"
    expect(page).to have_content 'Log In'
  end

  it 'Allows registered users to login and logout' do 
    user = FactoryGirl.create(:user)

    visit root_url
    click_on "Log In"
    fill_in 'Email', with:  user.email
    fill_in 'Password', with: user.password
    click_button "Submit"
    click_link "Log Out"
    expect(page).to have_content 'Logged out!'
  end



end
#require 'rails_helper'
#
#describe "SignUpProcess", :type => :feature do
#
#	before { visit signup_path }
#
#	let(:submit) { "Create my account" }
#

#