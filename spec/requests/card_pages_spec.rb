require 'spec_helper'

describe "Card Pages" do

	subject { page }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:deck) { FactoryGirl.create(:deck, user: user) }
	
	before do 
		sign_in user
	end

	describe "card creation" do 
		before do 
			visit edit_deck_path(deck)
			click_link "New card"
		end

		describe "with invalid information" do 

			it "should not create a deck" do 
				expect { click_button "Save card" }.should_not change(Card, :count)
			end

			describe "error messages" do 
				before { click_button "Save" }
				it { should have_selector('div', class: "alert-error") }
			end
		end

		describe "with valid information" do 
			let(:front_text) { "Front Text" }
			let(:back_text)  { "Back Text" }

			before do 
				fill_in "Front text", with: front_text
				fill_in "Back text", with: back_text
			end
 
			it "should create a card" do 
				expect { click_button "Save" }.should change(Card, :count).by(1)
			end

			describe "after creating a card" do 
				before { click_button "Save" }

				it { should have_selector('title', text: deck.title) }
				it { should have_selector('h4', text: front_text) }
				it { should have_selector('div', class: "alert alert-success") }
			end
		end
	end

	describe "edit" do 
		let!(:card) { FactoryGirl.create(:card, deck: deck, next_review: Time.now) }
		before do 
			visit edit_deck_path(deck)
			click_link "Edit"
		end

		describe "page" do 
			it { should have_selector('title', text: "Edit Card") }
			it { should have_selector('h1',    text: "Edit Card") }
		end

		describe "with invalid information" do 
			before { click_button "Save changes" }

			describe "error messages" do 
				it { should have_selector('div', class: "alert alert-error") }
			end
		end

		describe "with valid information" do 
			before do 
				fill_in "Front text", with: "New Front"
				fill_in "Back text",  with: "New Back"
				click_button "Save changes"
			end

			let(:time_now) { Time.now }

			it { should have_selector('div', class: "alert alert-success", text: "Card updated.") }
			it { should have_selector('h4',  text: "New Front") }
			specify { card.reload.front_text.should == "New Front" }
			specify { card.reload.back_text.should == "New Back" }
			specify { card.reload.next_review.should be_within(1.second).of(time_now) }
		end
	end
end
