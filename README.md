## A clone of fut-std to add auth basic with no gems: Ruby slim admin
## Authe and Auth with basic and pundit (Pundit rocks)

**Rails 4.2.5 Ruby 2.3.1 (Like to up to Rails 5.0.1)**

## What I am aming for 
Three roles split by enum
auser puser and nuser (Admin user - Power user - normal user)

1. admin user can do all
2. all can edit own profile
3. puser can edit other profile but not change roles
4. puser can list users

## How this was built
**Clone the std app to your desktop as the name of the new application**
> git clone https://github.com/yoyozi/reponame.git newreponame

**Create newreponame on github**
**Set the remote to freshly created repo**

> git remote set-url origin https://github.com/yoyozi/newreponame.git

**Submit to repo just created**
> git add -A
> git commit -m "Ready" 
> git push -u origin master

**Change deploy.rb and production.rb so IP and APPNAME are same as yours**
**Create application.yml, database.yml and secrets.yml file (Figaro and ENV VARS hidden)**
# MAKE SURE .gitignore EXCLUDES these files from being added to your repo!!

## Basic Auth and how it was built 

gem 'bcrypt'
After saving the Gemfile we need to run bundle.
bundle
Generate a Root Page
As a start we create a Page controller with an index view:

> rails g controller Page index

We use that view as the root_path:

config/routes.rb

Rails.application.routes.draw do
  get 'page/index'
  root 'page#index'
end

**We **start the rails development server**

rails s

Fire up the browser and open http://0.0.0.0:3000
Generate a User scaffold

We use a User model to store the user information and the password digest. We do not store the password in clear text in the database.

rails g scaffold User first_name last_name email password:digest
rake db:migrate

In the User model we add a couple of validations and a to_s method.

> app/models/user.rb

```
class User < ActiveRecord::Base
  has_secure_password
  validates :first_name,
            presence: true
  validates :last_name,
            presence: true
  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }
  def to_s
    "#{first_name} #{last_name}"
  end
end
```

**Create a new user**

We create the User “Jon Smith” with http://127.0.0.1:3000/users/new
Create a Session controller

Having a User model is nice but we need a Session mechanism to create a login and logout procedure. Because we live in a RESTful world login would be new plus create and logout would be destroy in a Sessions controller.

> rails g controller sessions new create destroy

Now we create a couple of routes for this to work:

config/routes.rb

```
Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :users
  get 'page/index'
  root 'page#index'
end
```

Login Form
The login form is the new.html.erb view for a new Session.
app/views/sessions/new.html.erb

```
<h1>Log In</h1>
<%= form_tag sessions_path do %>
<div class="field">
<%= label_tag :email %><br>
<%= text_field_tag :email %>
</div>
  <div class="field">
    <%= label_tag :password %><br>
<%= password_field_tag :password %>
</div>
  <div class="actions">
    <%= submit_tag "Log In" %>
</div>
<% end %>
```

**Session Controller**
The Session controller needs 3 actions:

    new
    create
    destroy

With that we use the RESTful approach.
app/controllers/sessions_controller.rb

```
class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      render :new
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
```

Create a current_user method
We need a mechanism to access the current_user everywhere in the application. For that we add a current_user method to the ApplicationController and use helper_method to provide a helper method for the views too.
app/controllers/application_controller.rb

```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  private
  def current_user
    User.where(id: session[:user_id]).first
  end
  helper_method :current_user
end
```

To show a user if he/she is already logged in and if not where to login or where to sign up we add a little header HTML in application.html.erb
Additionally I add some code to show flash messages if there are any.
app/views/layouts/application.html.erb

```
<div id="user_header">
<% if current_user %>
Logged in as <%= current_user.email %>.
<%= link_to "Log Out", logout_path %>
<% else %>
<%= link_to "Sign Up", signup_path %> or
<%= link_to "Log In", login_path %>
<% end %>
</div>
<% flash.each do |key, value| %>
<%= content_tag(:div, class: "alert alert-#{key}") do %>
<p><%= value %></p>
<% end %>
<% end %>
```

Because we render the flash messages in application.html.erb we can delete them in the following files:

    app/views/users/show.html.erb
    app/views/users/index.html.erb

<p id="notice"><%= notice %></p>

## Posts Scaffold to setup Authorization

We start with a Post scaffold.

> rails g scaffold Post user:references title content:text
rake db:migrate

Because we render the flash messages in application.html.erb we can delete them in the following files:

    app/views/posts/show.html.erb
    app/views/posts/index.html.erb

The Post model needs a couple of validations and a to_s method:
app/models/post.rb

```
class Post < ActiveRecord::Base
  belongs_to :user
  validates :title,
            presence: true
  validates :content,
            presence: true
  validates :user,
            presence: true
  def to_s
    title
  end
end
```

And the User model needs a has_many association to the Post model:
app/models/user.rb

has_many :posts, dependent: :destroy

Because we’ll take care of the user_id attribute in the controller we can delete the following code in the Post form:
app/views/posts/_form.html.erb

```
<div class="field">
<%= f.label :user_id %><br>
<%= f.text_field :user_id %>
</div>
```

And because we will not send the user_id through the form we can remove that from the post_params method in the Post controller too:
app/controllers/posts_controller.rb

# Only allow a trusted parameter "white list" through.

```
def post_params
  params.require(:post).permit(:title, :content)
end
```

Lastly we have to change the create method in the same controller to build a new post with the current_user.posts.build:
app/controllers/posts_controller.rb

```
# POST /posts
def create
  @post = current_user.posts.build.new(post_params)
  if @post.save
    redirect_to @post, notice: 'Post was successfully created.'
  else
    render :new
  end
end
```

For easier navigation I’ll add two links to our navigation.
app/views/layouts/application.html.erb

```
<%= link_to 'Home', root_path %> |
<%= link_to 'Posts', posts_path %> |
<% if current_user %>
Logged in as <%= current_user.email %>.
<%= link_to "Log Out", logout_path %>
<% else %>
<%= link_to "Sign Up", signup_path %> or
<%= link_to "Log In", login_path %>
<% end %>
```

Now a user can create, edit and destroy a post. But unfortunately any user can edit any post now and even somebody who is not logged in at all could edit and destroy a post.
We need authorization to fix that.
before_action :authorize

We create a private authorize method in the Post controller and trigger it with a before_action. Because we don’t need it for the index and show views we can except those.
app/controllers/posts_controller.rb

```
class PostsController < ApplicationController
  [...]
  before_action :authorize, except: [:show, :index]
  [...]
  def authorize
    if current_user.nil?
      redirect_to login_url, alert: "Not authorized! Please log in."
    else
      if @post && @post.user != current_user
        redirect_to root_path, alert: "Not authorized! Only #{@post.user} has access to this post."
      end
    end
  end
end
```

Links in the view

Obvioulsy it doesn’t make any sense to show a link to a person who is not logged in. A couple of if clauses and the current_user helper will fix that:
app/views/posts/index.html.erb

```
<h1>Listing Posts</h1>
<table>
<thead>
<tr>
<th>User</th>
<th>Title</th>
<th>Content</th>
<th colspan="3"></th>
</tr>
</thead>
<tbody>
<% @posts.each do |post| %>
<tr>
<td><%= post.user %></td>
<td><%= post.title %></td>
<td><%= post.content %></td>
<td><%= link_to 'Show', post %></td>
<td><% if current_user && post.user == current_user %><%= link_to 'Edit', edit_post_path(post) %><% end %></td>
<td><% if current_user && post.user == current_user %><%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %><% end %></td>
</tr>
<% end %>
</tbody>
</table>
<br>
<% if current_user %> <%= link_to 'New Post', new_post_path %>
<% end %>
```

After that we’ll do the same in the show view.

```
<p>
  <strong>User:</strong>
  <%= @post.user %>
</p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= @post.content %>
</p>

<% if current_user && post.user == current_user %>
  <%= link_to 'Edit', edit_post_path(@post) %>
<% end%>
   |
<%= link_to 'Back', posts_path %>
```

## Testing testing testing
## Setup the testing environment and GEMS

```
gem 'faker'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end
```

> bundle

**Setup rpec**

>rails g rspec:install

Edit the rails helper file
```
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
require "pundit/rspec"


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
```

> mkdir ./spec/factories (if doesnt exist)

**'shoulda-matchers' setup**

Add to the rails-helper.rb file in spec

```
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```


**'database_cleaner' setup**

Database Cleaner is a set of strategies for cleaning your database in Ruby between test runs. It helps to ensure a clean state for testing.

Add to the rails-helper.rb file in spec

```
config.use_transactional_fixtures = false
```

> mkdir ./spec/support 
> vi ./spec/support/database_cleaner.rb 

```
RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

**'faker' and 'factory_girl' setup**

Factory Girl allows you create objects that you need in your tests which can include default values. With faker, you will be able to create random objects for your test instead of using just one default value.

An example

```
# spec/factories/posts.rb

FactoryGirl.define do
  factory :post do
    title     { Faker::Title.title }
    body         { Faker::Body.body }
  end
end
```

You do not have to explicitly enter objects. Factory Girl uses the random (fake) values generated by faker to create factories that will be used whenever you run your test.

```
***spec/models/post_spec.rb***

require 'rails_helper'

RSpec.describe Post, type: :model do
  it "has a valid factory" do
    expect(posty).to be_valid
  end
end
```

**Tel rails what you are using to test with so it can auto generate testing files**

Open config/application.rb and include the following code inside the Application class:

```
config.generators do |g|
  g.test_framework :rspec,
    :fixtures => true,
    :view_specs => false,
    :helper_specs => false,
    :routing_specs => false,
    :controller_specs => true,
    :request_specs => true
  g.fixture_replacement :factory_girl, :dir => "spec/factories"
end
```

:fixtures => true specifies to generate a fixture for each model (using a Factory Girl factory, instead of an actual fixture)

:view_specs => false says to skip generating view specs. 

:helper_specs => false skips generating specs for the helper files Rails generates with each controller. As your comfort level with RSpec improves, consider changing this option to true and testing these files.

:routing_specs => false omits a spec file for your config/routes.rb file. If your application is simple, as the one in this book will be, you’re probably safe skipping these specs. As your application grows, however, and takes on more complex routing, it’s a good idea to incorporate routing specs.

g.fixture_replacement :factory_girl tells Rails to generate factories instead of fixtures, and to save them in the spec/factories directory.

## Testing the models (post and user)

**Create a spec to test the post model ./spec/model/post_spec.rb**

```
require 'rails_helper'

RSpec.describe Post, 'validation', type: :model do

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:content) }

  it { should validate_presence_of(:user_id) }

end

RSpec.describe Post, 'association', type: :model do
  it { should belong_to(:user) }
end
```

Get them to pass 

**Create a spec to test the user model ./spec/model/user_spec.rb**

```
require 'rails_helper'

RSpec.describe User, 'validation', type: :model do

  it { should validate_presence_of(:first_name) }

  it { should validate_presence_of(:last_name) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

end

RSpec.describe User, 'association', type: :model do
  it { should have_many(:posts) }
end
```

In rails_helper.rb
# Dont have to specify the type ie model in the test as it gets infered
config.infer_spec_type_from_file_location!

Now you can remove the "type model" from the user and post model specs

## Setup admin

```
./spec/models/user_spec.rb add 
it { should respond_to(:admin) }
it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
```

These tests fails 

> rails generate migration add_admin_to_users admin:boolean
> rake db:migrate
> rake db:test:prepare

Tests pass
After adding roles with bolean and then with enum I have written some tests that all pass however the issue with three user roles not being granular enough sucks so I am going to namespace and use both enum and boolean

These are the tests that pass (Features): problem is that puser (power user can edit admins profile Dow!)

```
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
```

## Added session timeout (in config/session_store.rb)
Rails.application.config.session_store :cookie_store, key: '_std_session', :expire_after => 20.minutes

## Adding pundit gem and bundling
gem 'pundit', '~> 1.1'
rails g pundit:install

./policies/user_policy.rb 
```
class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  # Methods for each controller action

  def index?
    # Is the current user an admin? If they are they can visit index page, if not 
    # they get failure notice that is setup in the application controller
    @current_user.admin? || @current_user.puser?
  end

  def edit?
    #@current_user.admin? || @current_user.puser? || 
    @current_user.id == @user.id || @current_user.admin?
  end

  def show?
    # If the user is an admin is allowed to show a users page or the current user is viewing his own user page
    #@current_user.admin? || @current_user.puser? || 
    @current_user.id == @user.id || @current_user.admin?
  end

  def update?
    @current_user.id == @user.id || @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

  def new?
    @current_user.admin?
  end

  def create?
    @current_user.admin?
  end

end

```



NEED TO FINISH THE TESTS and finalize
For now need to continue.




## To load this app to build on Digital Ocean

## On remote: Sign up with Digital Ocean or rebuild your existing droplet
Delete the fingerprints of the known host in the known hosts file on your local machine

**User accounts and remote ssh. On droplet**
Log in with you cert and change root password
> passwd
> adduser username
> adduser deploy_user
> gpasswd -a username sudo
> gpasswd -a deploy_user sudo

**Make editing the sudo file use vim**
__AFTER Defaults        env_reset
>Defaults        editor=/usr/bin/vim

**Make the deploy user passwordless when running listed commands/apps**
> visudo

```
for now
#deploy_user ALL=(ALL) NOPASSWD:ALL
will change later to 
deploy_user ALL=NOPASSWD:/usr/bin/apt-get
```

## On local machine (on mac use):
> ssh-copy-id deploy_user@x.x.x.x
> ssh-copy-id username@x.x.x.x

**Test that you can login with the deployer user and your own username, and su to root BEFORE removing root remote login!!!**
> ssh -p xxxx deployer@x.x.x.x
> sudu su -

**For better security, it's recommended that you disable remote root login**
> vi /etc/ssh/sshd_config

```
Port 22 # change this to whatever port you wish to use
Protocol 2
PermitRootLogin no
(At the end of sshd_config, enter):
UseDNS no
AllowUsers username username
```

**To squeulch the perl WARNIG**

Edit the /etc/ssh/ssh_config file
> vi /etc/ssh/ssh_config
Find the line "SendEnv LANG LC_*"

```
# SendEnv LANG LC_*
```

Save the file
> reload ssh

## Digital Ocean specific

Configure the time zone and ntp service
> sudo dpkg-reconfigure tzdata
> sudo apt-get install ntp

Configure swap space
> sudo fallocate -l 4G /swapfile
> sudo chmod 600 /swapfile
> sudo mkswap /swapfile
> sudo swapon /swapfile
> sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

**Setup ssh login to Github from the droplet server so no password is used to pull repository**

As the deploying user run
> ssh-keygen -t rsa

Cut and paste the output of below (the public key) to your github repo
> cat ./.ssh/id_rsa.pub

Test the login to github
> ssh -T git@github.com
Should be a welcome message

Set the locale (add at end of file)
> sudo vi /etc/environment
> export LANG=en_US.utf8

## On local 

In the Capfile make sure these are all commented out
```
#require 'capistrano/figaro_yml'
#require "capistrano/rbenv"
#require "capistrano/bundler"
#require "capistrano/rails/assets"
#require "capistrano/rails/migrations"
#require 'capistrano/safe_deploy_to'
#require 'capistrano/unicorn_nginx'
#require 'capistrano/rbenv_install'
#require 'capistrano/secrets_yml'
#require 'capistrano/database_yml'
```

## Run the task droplet:dsetup
Make sure file looks like this
```
namespace :droplet do

  desc "Updating the server"  
  task :setup do   
      on roles(:app) do 
        execute "echo 'export LANG=\"en_US.utf8\"' >> ~/.bashrc"
        execute "echo 'export LANGUAGE=\"en_US.utf8\"' >> ~/.bashrc"
        execute "echo 'export LC_ALL=\"en_US.UTF-8\"' >> ~/.bashrc"
        execute "source /home/#{fetch(:user)}/.bashrc"
        execute "source /home/deployer/.bashrc"
        execute :sudo, "/usr/bin/apt-get -y update"
        execute :sudo, "/usr/bin/apt-get -y install python-software-properties"
        execute :sudo,  "apt-get -y install git-core curl zlib1g-dev logrotate build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev libpq-dev"
        execute :sudo, "apt-get -y install nginx"
        execute :sudo, "apt-get -y install postgresql postgresql-contrib libpq-dev"
        execute :sudo, "service postgresql start"
        execute 'echo | sudo add-apt-repository ppa:chris-lea/node.js'          
        execute :sudo, "/usr/bin/apt-get -y install nodejs"
        execute :sudo, "/usr/bin/apt-get -y update"  
    end  
  end 
end
```

## On remote: setup postgresql on the remote server
> sudo -u postgresql createuser -s rails-psql-user
> sudo -u postgres psql
> \password (set the postgres user password)
> \password rails-psql-user (set the rails-user password)
> sudo -u postgres createdb chraig_production
> \q

## on local

**Ensure IP address and the project repo is adjusted to suite**
deploy.rb and production.rb

Create the ./config/secrets.yml file and use keys "rake secret" to populate
```
development:
  secret_key_base: xxx
test:
  secret_key_base: xxxcxccv
production:
  secret_key_base: <%= ENV['SECTRETSTRING'] %>
```

Create ./config/application.yml file for figaro
```
production:
   DBPW: thepw
   SECTRETSTRING: "the string from rake secret"
```

Create the database.yml file
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: localhost

development:
  <<: *default
  database: db_development

test:
  <<: *default
  database: db_test

production:
  <<: *default
  database: db_production
  username: rails-psql-user
  password: <%= ENV['production-DB-password'] %>
```

Create linked files and directories by adding into deploy.rb
```
set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
```

In the Capfile make sure these are all NOT commented out
```
require 'capistrano/figaro_yml'
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require 'capistrano/safe_deploy_to'
require 'capistrano/unicorn_nginx'
require 'capistrano/rbenv_install'
require 'capistrano/secrets_yml'
require 'capistrano/database_yml'
```

## Setup the server

> cap -T
> cap production safe_deploy_to:ensure
> cap production setup
> cap production deploy


