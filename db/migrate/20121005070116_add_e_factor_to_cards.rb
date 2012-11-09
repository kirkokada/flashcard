class AddEFactorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :e_factor, :decimal
  end
end
