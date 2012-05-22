class AddMissingIndices < ActiveRecord::Migration
  def up
    add_index :games, :id
    add_index :teams, :game_id
    add_index :sides, :team_id
    add_index :sides, :player_id
    add_index :players, :id
    add_index :news, :id
    add_index :comments, [:commentable_id, :commentable_type]
  end

  def down
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :news, :id
    remove_index :players, :id
    remove_index :sides, :player_id
    remove_index :sides, :team_id
    remove_index :teams, :game_id
    remove_index :games, :id
  end
end
