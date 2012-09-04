require 'spec_helper'

describe "Deck pages" do
  
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before do 
		sign_in user
	end

	describe "deck creation" do
		let(:deck_title) { "Example Deck" }

		before do 
			visit root_path
			click_link "Create Deck"
		end

		describe "with invalid information" do 
			
			it "should not create a deck" do 
				expect { click_button "Save" }.should_not change(Deck, :count)
			end

			describe "error messages" do 
				before { click_button "Save" }
				it { should have_selector('div', class: "alert-error") }
			end

			describe "followed by valid submit" do 
				before do 
					fill_in "deck_title", with: deck_title
					click_button "Save"
				end

				it { should_not have_selector('div', text: "Form contains") }
			end
		end

		describe "with valid information" do 
			before { fill_in 'deck_title', with: deck_title }
			
			it "should create a deck" do 
				expect { click_button "Save" }.should change(Deck, :count).by(1)
				page.should have_selector('span', text: "1 deck")
			end

			describe "after successful submit" do 
				before { click_button "Save" }
				it { should have_selector('h4', text: deck_title) }
			end
		end
	end

	describe "deck list", js: true do 
		before do 
			20.times do 
				FactoryGirl.create(:deck, user: user)
			end
			visit root_path
		end

		describe "when deleting a deck" do 
			before do 
				within "div#deck20" do 
					click_link "Delete"
				end
			end

			it { should_not have_selector('div', id:"deck20") }
			it { should     have_selector('div', id:"deck10") }
		end
	end
end
