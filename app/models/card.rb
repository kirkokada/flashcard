class Card < ActiveRecord::Base
  attr_accessible :back_text, :front_text, :next_review, :e_factor
  belongs_to :deck
  before_validation :set_e_factor
  before_validation :set_first_review

  validates :back_text, presence: true
  validates :front_text, presence: true
  validates :next_review, presence: true
  validates :deck_id, presence: true
  validates :e_factor, presence: true, numericality: { greater_than_or_equal_to: 0 }

  default_scope order: "cards.next_review DESC"

  private
  	def set_e_factor
  		self.e_factor = 2.5
  	end

    def set_first_review
      self.next_review = DateTime.now
    end
end
