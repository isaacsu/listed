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

ActiveRecord::Schema.define(version: 20171103152017) do

  create_table "authors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "secret"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "username"
    t.string   "display_name"
    t.text     "bio",          limit: 65535
    t.string   "link"
    t.string   "email"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token"
    t.string   "item_uuid"
    t.string   "title"
    t.text     "text",       limit: 16777215
    t.integer  "author_id"
    t.boolean  "unlisted",                    default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "subscribers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "author_id"
    t.integer  "subscriber_id"
    t.string   "token"
    t.boolean  "verified"
    t.string   "frequency",     default: "daily"
    t.datetime "last_mailing"
    t.boolean  "unsubscribed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_id"], name: "index_subscriptions_on_author_id", using: :btree
    t.index ["frequency"], name: "index_subscriptions_on_frequency", using: :btree
    t.index ["subscriber_id"], name: "index_subscriptions_on_subscriber_id", using: :btree
    t.index ["unsubscribed"], name: "index_subscriptions_on_unsubscribed", using: :btree
    t.index ["verified"], name: "index_subscriptions_on_verified", using: :btree
  end

end
