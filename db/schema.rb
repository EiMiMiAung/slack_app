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

ActiveRecord::Schema.define(version: 2019_07_16_035239) do

  create_table "h_cha_starmsgs", force: :cascade do |t|
    t.integer "chamsg_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_cha_threads", force: :cascade do |t|
    t.integer "chamsg_id"
    t.integer "user_id"
    t.string "chathread_msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_chastarmsgs", force: :cascade do |t|
    t.integer "chamsg_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_d_threads", force: :cascade do |t|
    t.integer "dmsg_id"
    t.integer "user_id"
    t.string "thread_msg"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_dstarmsgs", force: :cascade do |t|
    t.integer "dmsg_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_dthreads", force: :cascade do |t|
    t.integer "dmsg_id"
    t.integer "user_id"
    t.string "thread_msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_mentions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "chamsg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_chas", force: :cascade do |t|
    t.string "name"
    t.boolean "isprivate"
    t.integer "workspace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_workspaces", force: :cascade do |t|
    t.integer "user_id"
    t.string "workspace_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_chamsgs", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "cha_id"
    t.string "msg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workspace_id"
  end

  create_table "t_dmsgs", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "msg"
    t.boolean "isread"
    t.integer "workspace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_relationships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "workspace_id"
    t.integer "cha_id"
    t.boolean "isdeactivated"
    t.integer "msg_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
