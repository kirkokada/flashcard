class Deck < ActiveRecord::Base
  attr_accessible :title, :description
  
  belongs_to :user

  default_scope order: "decks.updated_at DESC" 

  validates :title, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
end
