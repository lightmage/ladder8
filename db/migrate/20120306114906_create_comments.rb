class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, :player
      t.string     :commentable_type
      t.text       :body
      t.timestamp  :created_at
    end
  end
end
