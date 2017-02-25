class ApplicationController < ActionController::Base
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
end