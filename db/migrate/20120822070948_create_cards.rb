class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :deck_id
      t.string :front_text
      t.string :back_text

      t.timestamps
    end
  end
end
