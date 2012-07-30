require 'spec_helper'

describe "StaticPages" do
	subject { page }
  
  describe "Home page" do 
  	before { visit root_path }

		it { should have_selector('title', text: full_title('')) }
		it { should have_selector('h1',    text: "Flashcard") }
		it { should_not have_selector('title', text: "Flashcard |") }
	end

	describe "Help page" do 
		before { visit help_path }

		it { should have_selector('title', text: full_title('Help')) }
		it { should have_selector('h1',    text: 'Help') }
	end

	describe "About page" do 
		before { visit about_path }

		it { should have_selector('title', text: full_title('About Us')) }
		it { should have_selector('h1', text: "About Us") }
	end

	describe "Contact page" do 
		before { visit contact_path }

		it { should have_selector('title', text: full_title('Contact')) }
		it { should have_selector('h1', text: 'Contact') }
	end
end
