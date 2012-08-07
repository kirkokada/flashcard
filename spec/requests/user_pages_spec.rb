require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do 
  	before { visit signup_path }

  	it { should have_selector('title', text: full_title('Sign Up')) }
  	it { should have_selector('h1', text: 'Sign Up') }

  	describe "with invalid information" do 
  		it "should not create a user" do 
  			expect { click_button "Submit" }.not_to change(User, :count)
  		end

  		describe "after failed submit" do
  			before { click_button "Submit" } 
  			it { should have_selector('div', class: "alert-error") }
  		end
  	end

  	describe "with valid information" do
  		before do
		  	fill_in "Name", with: "Example User"
		  	fill_in "Email", with: "user@example.com"
		  	fill_in "Password", with: "password"
		  	fill_in "Confirmation", with: "password"
		  end
	  	
	  	it "should create a user" do 
	  		expect { click_button "Submit" }.to change(User, :count).by(1)
	  	end

	  	describe "after creating a user" do 
	  		before { click_button "Submit" }
	  		let(:user) { User.find_by_email('user@example.com') }

	  		it { should have_selector('title', text: user.name)}
	  		it { should have_selector('div', class: "alert-success", 
	  			                               text: "Welcome to Flashcard") }
        it { should have_link('Profile', href: user_path(user)) }
        it { should have_link('Sign out', href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }
	  	end
	  end
  end

  describe "profile page" do 
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

  	it { should have_selector('title', text: user.name) }
  	it { should have_selector('h1', text: user.name) }
  end
end
