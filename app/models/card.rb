class Card < ActiveRecord::Base
  attr_accessible :back_text, :deck_id, :front_text
end
