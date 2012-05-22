class CreateSides < ActiveRecord::Migration
  def change
    create_table :sides do |t|
      t.boolean    :confirmed, :default => false
      t.float      :deviation, :mean
      t.integer    :number
      t.references :player, :team
      t.string     :color, :faction, :leader
    end
  end
end
