class AddReviewTimesToCards < ActiveRecord::Migration
  def change
    add_column :cards, :next_review, :time
    add_index :cards, [:next_review, :deck_id]
  end
end
