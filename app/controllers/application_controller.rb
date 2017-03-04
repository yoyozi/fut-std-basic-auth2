class ApplicationController < ActionController::Base

	# Added for Pundit
	include Pundit
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	# Then define the method for Pundit as a method to send notice as a flash message

  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

  	private

	# We need a mechanism to access the current_user everywhere in the application. 
	# For that we add a current_user method to the ApplicationController and use 
	# helper_method to provide a helper method for the views too.
  	def current_user
  	  User.where(id: session[:user_id]).first
  	  # other way of writng using or equals operand : @current_user ||= User.find(session[:user_id]) if session[:user_id]
  	end

  	helper_method :current_user

  	def user_not_authorized
  		flash[:alert] = "Access denied."
  		# Redirect them to page they were on or send to root page
  		redirect_to root_url
  	end
  	

end