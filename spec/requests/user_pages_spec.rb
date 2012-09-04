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

        describe "following sign in" do
          before { sign_in user }

          describe "when revisiting signup page" do 
            before { visit signup_path }
            it { should have_selector('title', text: user.name) }
          end

          describe "when submitting POST request to Users#create action" do 
            before { post users_path }
            specify { response.should redirect_to user_path(user) }
          end
        end
	  	end
	  end
  end

  describe "profile page" do 
  	let(:user)  { FactoryGirl.create(:user) }
    let!(:deck1) { FactoryGirl.create(:deck, user: user) }
    let!(:deck2) { FactoryGirl.create(:deck, user: user) }

  	before { visit user_path(user) }

  	it { should have_selector('title', text: user.name) }
  	it { should have_selector('h1',    text: user.name) }

    describe "decks" do 
      it { should have_selector('h4', text: deck1.title) }
      it { should have_selector('h4', text: deck2.title) }
      it { should have_content(user.decks.count) }
      it { should have_link('Delete', href: deck_path(deck1)) }
      it { should have_link('Delete', href: deck_path(deck2)) }
    end
  end

  describe "edit" do 
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user 
      visit edit_user_path(user)
    end

    describe "page" do 
      it { should have_selector('title', text: "Edit user") }
      it { should have_selector('h1',    text: "Update your profile") }
    end

    describe "with invalid information" do 
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do 
      let(:new_name) { "New Name" }
      let(:new_email) { "new@email.com" }
      before do 
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: user.password 
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text:  new_name) }
      it { should have_selector('div',   class: "alert alert-success") }
      it { should have_link('Sign out',  href:  signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do 
    
    let (:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    before (:each) do 
      sign_in user 
      visit users_path
    end
    
    describe "page" do 
      it { should have_selector('title', text: 'All Users') }
      it { should have_selector('h1', text: 'All Users') }
    end

    describe "pagination" do 
      
      it { should have_selector('div', class: "pagination") }

      describe "it should list each user" do 
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do 
      
      it { should_not have_link('Delete') }

      describe "as an admin user" do 
        let (:admin) { FactoryGirl.create(:admin) }
        before do 
          sign_in admin
          visit users_path
        end

        it { should have_link('Delete', href: user_path(User.first)) }

        it "should be able to delete another user" do 
          expect { click_link('Delete') }.to change(User, :count).by(-1)
        end

        it "should not be able to delete himself" do 
          expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
          page.should have_selector('div', class:'alert alert-error')
        end

        it { should_not have_link('Delete', href: user_path(admin)) }
      end

      describe "as a non-admin user" do 
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do 
          before { delete user_path(user) }
          specify { response.should redirect_to root_path }
        end
      end
    end
  end
end
