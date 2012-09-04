require 'spec_helper'

describe Deck do
  let(:user) { FactoryGirl.create(:user) }
  before { @deck = user.decks.build(title: "Example Deck") }

  subject { @deck }

  it { should respond_to :user_id }
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :user }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do 
  	it "should not allow access to user_id" do 
  		expect do 
  			Deck.new(user_id: user.id)
  		end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "when user_id is not present" do 
    before { @deck.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank title" do 
    before { @deck.title = "" }
    it { should_not be_valid }
  end

  describe "with title that is too long" do 
    before { @deck.title = "a" * 51 }
    it { should_not be_valid }
  end
end
