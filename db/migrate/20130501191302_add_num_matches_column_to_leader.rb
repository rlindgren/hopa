class AddNumMatchesColumnToLeader < ActiveRecord::Migration
  def change
    add_column :leaders, :num_matches, :integer
  end
end
