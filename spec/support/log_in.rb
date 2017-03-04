require 'rails_helper'


def log_in(user)
		
            visit root_url
            click_on "Log In"
            fill_in 'Email', with:  user.email
            fill_in 'Password', with: user.password
            click_button "Submit"
	

end