
#require 'simplecov'
#SimpleCov.start

## This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?


require 'spec_helper'
require 'rspec/rails'
require 'ffaker'
require 'capybara/rspec'
require 'capybara/rails'
require 'shoulda/matchers'
require 'database_cleaner'


Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }


ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
 	config.integrate do |with|
   	with.test_framework :rspec
   	with.library :rails
 	end
 end



RSpec.configure do |config|
  
  # Allows us to call Create without saying FactoryGirl......
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = false
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)


  # config.include Features, type => feature
  config.include Capybara::DSL
  # config.include Features::SessionHelpers, type: :feature

  # Dont have to specify the type ie model in the test as it gets infered
  config.infer_spec_type_from_file_location!

end

