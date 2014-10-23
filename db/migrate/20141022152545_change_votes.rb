class ChangeVotes < ActiveRecord::Migration
  def change
    change_table :votes do |t|
      t.rename :product_id, :votable_id
      t.string :votable_type
    end

    add_index :votes, [:votable_type,:votable_id]  
  end
end
