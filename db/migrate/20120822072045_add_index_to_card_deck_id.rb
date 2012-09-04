class AddIndexToCardDeckId < ActiveRecord::Migration
  def change
  	add_index :cards, [:deck_id, :updated_at]
  end
end
