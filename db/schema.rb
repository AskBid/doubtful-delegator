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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200604120746) do

  create_table "delegations", force: :cascade do |t|
    t.string   "type"
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "pool_epoch_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "pool_epoches", force: :cascade do |t|
    t.float    "pool_size"
    t.integer  "total_stake"
    t.integer  "staker_reward"
    t.integer  "pool_reward"
    t.integer  "epoch"
    t.integer  "blocks"
    t.float    "tax"
    t.integer  "pool_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "pools", force: :cascade do |t|
    t.string   "ticker"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "balance"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
