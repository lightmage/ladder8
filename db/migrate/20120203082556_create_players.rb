class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.boolean :admin, :banned, :default => false
      t.float   :deviation, :deviation_initial, :mean, :mean_initial, :rating
      t.string  :avatar, :background, :color, :country, :nick, :nick_parameterized, :password_digest, :signature, :timezone
      t.text    :description
      t.timestamps
    end
  end
end
