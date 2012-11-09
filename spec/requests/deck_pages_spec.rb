require 'spec_helper'

describe "Deck pages" do
  
	subject { page }

	let!(:user) { FactoryGirl.create(:user) }
	before do 
		sign_in user
	end

	let(:title) { "Example Deck" }
	let(:description) { "Deck description"}

	describe "deck creation" do

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
					fill_in "Title", with: title
					fill_in "Description", with: description
					click_button "Save"
				end

				it { should_not have_selector('div', text: "Form contains") }
			end
		end

		describe "with valid information" do 
			before do
			 fill_in 'Title', with: title
			 fill_in 'Description', with: description
			end
			
			it "should create a deck" do 
				expect { click_button "Save" }.should change(Deck, :count).by(1)
				page.should have_selector('span', text: "1 deck")
			end

			describe "after successful submit" do 
				before { click_button "Save" }

				it { should have_selector('h4', text: title) }
				it { should have_content(description) }
			end
		end
	end

	describe "deck list", type: :request do
	  self.use_transactional_fixtures = false
		before do 
			20.times do 
				FactoryGirl.create(:deck, user: user)
			end
			visit root_path
		end

		describe "deck deletion" do

			it "should delete a deck" do
				expect do
					within "div#deck20" do 
						click_link "Delete"
					end
				end.should change(Deck, :count).by(-1)
			end

		describe "after successful delete", js: :true do
				before do 
					within "div#deck20" do 
						click_link "Delete"
						page.driver.wait_until(page.driver.browser.switch_to.alert.accept)
						page.driver.wait_until { page.has_content "Deck destroyed." }
					end
				end

				it { should have_selector('div', id:"deck20", class: "hidden") }
				it { should have_selector('div', id:"deck10") }
			end
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

	describe "review page" do

		describe "for a deck containing no cards" do
			let!(:empty_deck) { FactoryGirl.create(:deck, user: user) }

			before do
				visit root_path 
				click_link 'Review'
			end

			it { should have_content('This deck has no cards') }
		end

		describe "for a deck with cards" do
			let!(:review_deck) { FactoryGirl.create(:deck, user: user) }

			describe "not up for review" do
				let!(:card) { FactoryGirl.create(:card, deck: review_deck) }

				before do
					visit root_path 
					click_link 'Review'
				end

				it { should have_content('No cards up for review.') }
			end

			describe "up for review" do

				let!(:card) do
					Timecop.travel(Time.now - 1.day) do
						FactoryGirl.create(:card, deck: review_deck)
					end
				end

				before do
					visit root_path
					click_link 'Review'
				end

				it { should have_selector('title', text: "Reviewing: #{review_deck.title}") }
				it { should have_content('Ready?') }
				it { should have_link('Yes!', href: card_path(card)) }
				it { should have_link('Not yet...', href: root_path) }
			end
		end
	end
end
