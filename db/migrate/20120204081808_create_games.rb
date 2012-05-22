class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean    :confirmed_cache, :rby, :default => false
      t.integer    :turns
      t.references :map
      t.string     :era, :replay, :title, :version
      t.text       :chat
      t.timestamps
    end
  end
end
