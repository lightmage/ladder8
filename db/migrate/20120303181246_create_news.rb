class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :player
      t.string     :title
      t.text       :body
      t.timestamp  :created_at
    end
  end
end
