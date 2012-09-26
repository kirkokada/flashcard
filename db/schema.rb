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

ActiveRecord::Schema.define(:version => 20120907051302) do

  create_table "cards", :force => true do |t|
    t.integer  "deck_id"
    t.string   "front_text"
    t.string   "back_text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.time     "next_review"
  end

  add_index "cards", ["deck_id", "updated_at"], :name => "index_cards_on_deck_id_and_updated_at"
  add_index "cards", ["next_review", "deck_id"], :name => "index_cards_on_next_review_and_deck_id"

  create_table "decks", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  add_index "decks", ["user_id", "created_at"], :name => "index_decks_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
