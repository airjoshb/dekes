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

ActiveRecord::Schema.define(version: 20171003224702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name",            limit: 255
    t.string   "last_name",             limit: 255
    t.string   "address1",              limit: 255
    t.string   "address2",              limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zip",                   limit: 255
    t.integer  "user_id"
    t.string   "phone_number",          limit: 255
    t.integer  "fulfillment_option_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["fulfillment_option_id"], name: "index_addresses_on_fulfillment_option_id", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "fulfillment_options", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree
  add_index "line_items", ["sale_id"], name: "index_line_items_on_sale_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "menu"
    t.text     "description"
    t.string   "image",       limit: 255
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category"
    t.string   "slug"
    t.boolean  "available"
  end

  create_table "sales", force: :cascade do |t|
    t.string   "guid",                  limit: 255
    t.decimal  "total"
    t.integer  "status"
    t.boolean  "confirmation_sent"
    t.text     "note"
    t.string   "stripe_order_id",       limit: 255
    t.integer  "user_id"
    t.integer  "fulfillment_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cart_ids"
    t.string   "email"
  end

  add_index "sales", ["fulfillment_option_id"], name: "index_sales_on_fulfillment_option_id", using: :btree
  add_index "sales", ["user_id"], name: "index_sales_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
    t.string   "customer_id",            limit: 255
    t.string   "name",                   limit: 255
    t.string   "last_4_digits",          limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
