require 'spec_helper'

describe "StaticPages" do
	subject { page }

	shared_examples_for "all static pages" do 
		it { should have_selector('h1', text: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end
  
  describe "Home page" do 
  	before { visit root_path }
  	let(:heading)    { 'Flashcard' }
  	let(:page_title) { '' }

		it_should_behave_like "all static pages"
		it { should_not have_selector('title', text: "Flashcard |") }
		it { should have_link('Sign up now!', href: signup_path) }

		describe "after signing in" do
			let(:user) { FactoryGirl.create(:user) } 
			before do 
				sign_in user
				visit root_path
			end

			it { should have_link('Create Deck') }
		end
	end

	describe "Help page" do 
		before { visit help_path }
		let(:heading)    { 'Help' }
  	let(:page_title) { 'Help' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do 
		before { visit about_path }
		let(:heading)    { 'About Us' }
  	let(:page_title) { 'About Us' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do 
		before { visit contact_path }
		let(:heading)    { 'Contact' }
  	let(:page_title) { 'Contact' }

		it_should_behave_like "all static pages"
	end

	it "should have the right links on the layout" do 
		visit root_path
		click_link "About"
		page.should have_selector('title', text: full_title('About Us'))
		click_link "Help"
		page.should have_selector('title', text: full_title('Help'))
		click_link "Contact"
		page.should have_selector('title', text: full_title('Contact'))
		click_link "Home"
		page.should have_selector('title', text: full_title(''))
		click_link "Sign up now!"
		page.should have_selector('title', text: full_title('Sign Up'))
		click_link "Flashcard"
		page.should have_selector('title', text: full_title(''))
	end
end
