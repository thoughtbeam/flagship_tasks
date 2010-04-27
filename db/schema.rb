# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100427214602) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "submitter_id"
    t.string   "name"
    t.text     "body",         :default => ""
    t.integer  "status_id",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
