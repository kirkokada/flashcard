require 'spec_helper'

describe Card do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:deck) { FactoryGirl.create(:deck, user: user) }
  before { @card = deck.cards.build(front_text: "Front", back_text: "Back") }

  subject { @card }
end
