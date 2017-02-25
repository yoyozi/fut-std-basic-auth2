require 'rails_helper'

describe "Static pages", :type => :feature do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_link("Log In") }
    it { should have_no_link('Log out') }
  end


  describe "Other static pages", :type => :feature do

    end


  end
