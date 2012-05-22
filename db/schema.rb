# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120313112834) do

  create_table :comments, :force => true do |t|
    t.integer  "commentable_id"
    t.integer  "player_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
  end

  add_index :comments, ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table :games, :force => true do |t|
    t.boolean  "confirmed_cache", :default => false
    t.boolean  "rby",             :default => false
    t.integer  "turns"
    t.integer  "map_id"
    t.string   "era"
    t.string   "replay"
    t.string   "title"
    t.string   "version"
    t.text     "chat"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index :games, ["id"], :name => "index_games_on_id"

  create_table :maps, :force => true do |t|
    t.string  "name"
    t.string  "name_parameterized"
    t.integer "slots"
  end

  create_table :news, :force => true do |t|
    t.integer  "player_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
  end

  add_index :news, ["id"], :name => "index_news_on_id"

  create_table :players, :force => true do |t|
    t.boolean  "admin",  :default => false
    t.boolean  "banned", :default => false
    t.float    "deviation"
    t.float    "deviation_initial"
    t.float    "mean"
    t.float    "mean_initial"
    t.float    "rating"
    t.string   "avatar"
    t.string   "background"
    t.string   "color"
    t.string   "country"
    t.string   "nick"
    t.string   "nick_parameterized"
    t.string   "password_digest"
    t.string   "signature"
    t.string   "timezone"
    t.text     "description"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index :players, ["id"], :name => "index_players_on_id"

  create_table :sessions, :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index :sessions, ["session_id"], :name => "index_sessions_on_session_id"
  add_index :sessions, ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table :sides, :force => true do |t|
    t.boolean "confirmed", :default => false
    t.float   "deviation"
    t.float   "mean"
    t.integer "number"
    t.integer "player_id"
    t.integer "team_id"
    t.string  "color"
    t.string  "faction"
    t.string  "leader"
  end

  add_index :sides, ["player_id"], :name => "index_sides_on_player_id"
  add_index :sides, ["team_id"], :name => "index_sides_on_team_id"

  create_table :teams, :force => true do |t|
    t.integer "game_id"
    t.string  "name"
    t.boolean "won", :default => false
  end

  add_index :teams, ["game_id"], :name => "index_teams_on_game_id"

end
