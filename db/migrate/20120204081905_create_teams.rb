class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :game
      t.string     :name
      t.boolean    :won, :default => false
    end
  end
end
