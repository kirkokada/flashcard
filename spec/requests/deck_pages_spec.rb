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

	describe "edit page" do
		let(:deck) { FactoryGirl.create(:deck, user: user) } 
		before do 
			visit edit_deck_path(deck)
		end

		it { should have_selector('title', text: deck.title) }
		it { should have_selector('h1', text: "Edit Deck") }
		it { should have_link("New card", href: new_card_path) }

		describe "with invalid information" do 
			before { click_button "Save Changes" }
			it { should have_selector('div', class: "alert-error") }
		end

		describe "with valid information" do
			let(:new_title)       { "New Title" }
			let(:new_description) { "New Description" } 
			before do 
				fill_in "Title",       with: new_title
				fill_in "Description", with: new_description
				click_button "Save Changes"
			end

			it { should have_link(new_title) }
			it { should have_content(new_description) }
			specify { deck.reload.title.should == new_title }
			specify { deck.reload.description.should == new_description }
		end

		describe "after creating a new card" do 
			before do 
				click_link "New card"
				fill_in "Front", with: "Front"
				fill_in "Back", with: "Back"
				click_button "Save card"
			end

			it { should have_selector('title', text: deck.title) }
			it { should have_selector('div',   class: "alert-success") }
			it { should have_content("Front") }
		end
	end
end
