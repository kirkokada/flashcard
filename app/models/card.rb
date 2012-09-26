class Card < ActiveRecord::Base
  attr_accessible :back_text, :front_text, :next_review
  belongs_to :deck

  validates :back_text, presence: true
  validates :front_text, presence: true
  validates :next_review, presence: true
  validates :deck_id, presence: true

  default_scope order: "cards.next_review DESC"
end
