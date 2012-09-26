require 'spec_helper'

describe Card do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:deck) { FactoryGirl.create(:deck, user: user) }
  before { @card = deck.cards.build(front_text: "Front", back_text: "Back", next_review: Time.now ) }

  subject { @card }

  it { should respond_to(:front_text) }
  it { should respond_to(:back_text) }
  it { should respond_to(:next_review) }
  its(:deck_id) { should == deck.id } 

  describe "accessible attributes" do 
  	it "should not allow access to deck_id" do 
  		expect do 
  			Card.new(deck_id: deck.id)
  		end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "when deck_id is not present" do 
    before { @card.deck_id = nil }
    it { should_not be_valid }
  end

  describe "with blank front text" do 
    before { @card.front_text = "" }
    it { should_not be_valid }
  end

  describe "with blank back text" do 
  	before { @card.back_text = ""}
  	it { should_not be_valid }
  end
end
