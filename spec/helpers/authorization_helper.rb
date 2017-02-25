require 'rails_helper'
require 'ffaker'

module AuthorizationHelper

	def log_in(user)
	  fill_in "Email",    with: user.email
	  fill_in "Password", with: user.password
	  click_button "Submit"
	
	end

end