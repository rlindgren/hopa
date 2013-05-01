# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130501164721) do

  create_table "computers", :force => true do |t|
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "ties"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "total_games"
  end

  create_table "games", :force => true do |t|
    t.integer  "comp_wins"
    t.integer  "player_wins"
    t.integer  "ties"
    t.datetime "played_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "leader_id"
  end

  create_table "leaders", :force => true do |t|
    t.string   "name"
    t.string   "score"
    t.datetime "played_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
  end

  create_table "matches", :force => true do |t|
    t.integer  "comp_move"
    t.integer  "player_move"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "game_id"
  end

end
