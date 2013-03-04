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

ActiveRecord::Schema.define(:version => 20130107003743) do

  create_table "abbreviations", :force => true do |t|
    t.string   "code",       :limit => 20
    t.string   "label",      :limit => 80
    t.datetime "updated_at",               :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",               :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "additions", :force => true do |t|
    t.integer  "work_id",                                       :null => false
    t.text     "text"
    t.integer  "user_id",                                       :null => false
    t.string   "state",      :default => "new",                 :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "additions", ["work_id"], :name => "index_additions_on_work_id"

  create_table "alias", :force => true do |t|
    t.integer  "composer_id",                                    :null => false
    t.string   "name"
    t.datetime "updated_at",  :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",  :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "alias", ["composer_id"], :name => "index_alias_on_composer_id"

  create_table "codes", :force => true do |t|
    t.string   "code"
    t.string   "label"
    t.string   "context"
    t.string   "style"
    t.datetime "created_at", :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "composers", :force => true do |t|
    t.string   "state"
    t.string   "name",           :limit => 40
    t.string   "first_name"
    t.string   "alt_name"
    t.string   "alt_first_name"
    t.string   "oboist",         :limit => 1
    t.text     "misc_info"
    t.string   "life_info"
    t.integer  "born"
    t.integer  "dead"
    t.string   "info_born"
    t.string   "info_dead"
    t.string   "done",           :limit => 1
    t.text     "intern_info"
    t.datetime "created_at",                   :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                   :default => '2004-06-17 00:00:00', :null => false
    t.string   "nick_name"
    t.string   "affix_name"
  end

  add_index "composers", ["id"], :name => "index_composers_on_id", :unique => true

  create_table "composers_work_versions", :force => true do |t|
    t.integer  "composers_work_id"
    t.integer  "version"
    t.integer  "work_id"
    t.integer  "composer_id"
    t.datetime "created_at",        :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",        :default => '2004-06-17 00:00:00', :null => false
    t.string   "category",          :default => "also attributed to"
  end

  add_index "composers_work_versions", ["work_id"], :name => "index_composers_work_versions_on_work_id"

  create_table "composers_works", :force => true do |t|
    t.integer  "work_id",                                        :null => false
    t.integer  "composer_id"
    t.integer  "version"
    t.datetime "created_at",  :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",  :default => '2004-06-17 00:00:00', :null => false
    t.string   "category",    :default => "also attributed to"
  end

  add_index "composers_works", ["work_id"], :name => "index_composers_works_on_work_id"

  create_table "countries", :force => true do |t|
    t.string   "code",       :limit => 10
    t.string   "label",      :limit => 150
    t.datetime "created_at",                :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "document_usages", :force => true do |t|
    t.integer  "document_id"
    t.integer  "usage_id"
    t.string   "usage_type"
    t.datetime "updated_at",  :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",  :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.text     "info"
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at", :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "downloads", :force => true do |t|
    t.string   "kind"
    t.integer  "material_id"
    t.integer  "work_id"
    t.string   "link"
    t.string   "comment"
    t.datetime "created_at",  :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",  :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "instrumentations", :force => true do |t|
    t.string   "code",        :limit => 20
    t.string   "label",       :limit => 80
    t.string   "label_short", :limit => 60
    t.datetime "created_at",                :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                :default => '2004-06-17 00:00:00', :null => false
    t.integer  "parent_id"
  end

  add_index "instrumentations", ["id"], :name => "index_instrumentations_on_id", :unique => true

  create_table "instrumentations_work_versions", :force => true do |t|
    t.integer  "instrumentations_work_id"
    t.integer  "version"
    t.integer  "work_id"
    t.integer  "instrumentation_id"
    t.datetime "updated_at",               :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",               :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "instrumentations_work_versions", ["work_id"], :name => "index_instrumentations_work_versions_on_work_id"

  create_table "instrumentations_works", :force => true do |t|
    t.integer  "work_id",                                               :null => false
    t.integer  "instrumentation_id",                                    :null => false
    t.integer  "version"
    t.datetime "created_at",         :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",         :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "instrumentations_works", ["instrumentation_id"], :name => "index_instrumentations_works_on_instrumentation_id"
  add_index "instrumentations_works", ["work_id"], :name => "index_instrumentations_works_on_work_id"

  create_table "instruments", :force => true do |t|
    t.string   "label"
    t.integer  "order"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "instruments_works", :force => true do |t|
    t.integer  "work_id"
    t.integer  "instrument_id"
    t.integer  "occurences",    :default => 1
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "libraries", :force => true do |t|
    t.string   "state"
    t.integer  "country_id",                                                     :null => false
    t.string   "code_place",   :limit => 40
    t.string   "city",         :limit => 40
    t.string   "name"
    t.string   "label",        :limit => 80
    t.string   "www",          :limit => 200
    t.string   "done",         :limit => 1
    t.text     "misc_info"
    t.string   "active",       :limit => 1
    t.integer  "successor_id"
    t.text     "intern_info"
    t.datetime "created_at",                  :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                  :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "libraries", ["id"], :name => "index_libraries_on_id", :unique => true

  create_table "libraries_work_versions", :force => true do |t|
    t.integer  "libraries_work_id"
    t.integer  "version"
    t.integer  "work_id"
    t.integer  "library_id"
    t.string   "comment"
    t.datetime "updated_at",        :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",        :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "libraries_work_versions", ["work_id"], :name => "index_libraries_work_versions_on_work_id"

  create_table "libraries_works", :force => true do |t|
    t.integer  "work_id",                                       :null => false
    t.integer  "library_id"
    t.string   "comment"
    t.integer  "version"
    t.datetime "created_at", :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "libraries_works", ["work_id"], :name => "index_libraries_works_on_work_id"

  create_table "materials", :force => true do |t|
    t.string   "label"
    t.datetime "created_at", :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "problems", :force => true do |t|
    t.string   "category",   :limit => 50
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",               :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",               :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "publishers", :force => true do |t|
    t.string   "state"
    t.string   "name"
    t.string   "label",           :limit => 100
    t.string   "city",            :limit => 60
    t.string   "www",             :limit => 100
    t.string   "mail",            :limit => 100
    t.string   "verlag_category", :limit => 20
    t.text     "comment_german"
    t.text     "comment_english"
    t.string   "done",            :limit => 1
    t.string   "active",          :limit => 1
    t.integer  "successor_id"
    t.text     "intern_info"
    t.datetime "created_at",                     :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                     :default => '2004-06-17 00:00:00', :null => false
    t.integer  "country_id"
  end

  add_index "publishers", ["id"], :name => "index_publishers_on_id", :unique => true

  create_table "publishers_work_versions", :force => true do |t|
    t.integer  "publishers_work_id"
    t.integer  "version"
    t.integer  "publisher_id"
    t.integer  "work_id"
    t.string   "comment"
    t.string   "available",          :limit => 40
    t.datetime "updated_at",                       :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",                       :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "publishers_work_versions", ["work_id"], :name => "index_publishers_work_versions_on_work_id"

  create_table "publishers_works", :force => true do |t|
    t.integer  "publisher_id"
    t.integer  "work_id",                                                       :null => false
    t.string   "comment"
    t.string   "available",    :limit => 40
    t.integer  "version"
    t.datetime "created_at",                 :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                 :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "publishers_works", ["work_id"], :name => "index_publishers_works_on_work_id"

  create_table "quotations", :force => true do |t|
    t.string   "state",             :default => "default",             :null => false
    t.string   "label"
    t.string   "author"
    t.string   "print_location"
    t.string   "print_publisher"
    t.string   "print_year"
    t.string   "peter_locations"
    t.string   "peter_code"
    t.string   "admin_status"
    t.text     "peter_intern_info"
    t.string   "article"
    t.string   "title"
    t.string   "title_detail"
    t.text     "misc_info"
    t.text     "bruce_intern_info"
    t.datetime "created_at",        :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",        :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "quotations_works", :force => true do |t|
    t.integer  "work_id"
    t.integer  "quotation_id"
    t.string   "comment"
    t.datetime "created_at",   :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",   :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "quotations_works", ["work_id"], :name => "index_quotations_works_on_work_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sources", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "mail",       :limit => 200
    t.datetime "created_at",                :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at",                :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 40
    t.string   "mail",                      :limit => 40
    t.string   "logname",                   :limit => 10
    t.string   "password",                  :limit => 60
    t.string   "state",                                   :default => "default",             :null => false
    t.date     "first_visit"
    t.date     "last_visit"
    t.integer  "visits",                    :limit => 1,  :default => 0,                     :null => false
    t.string   "role",                                    :default => "read_only",           :null => false
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                              :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "version_comments", :force => true do |t|
    t.string   "text"
    t.datetime "created_at", :default => '2004-06-17 00:00:00', :null => false
    t.datetime "updated_at", :default => '2004-06-17 00:00:00', :null => false
  end

  create_table "work_relations", :force => true do |t|
    t.integer  "work_id"
    t.integer  "related_work_id"
    t.datetime "updated_at",      :default => '2004-06-17 00:00:00', :null => false
    t.datetime "created_at",      :default => '2004-06-17 00:00:00', :null => false
  end

  add_index "work_relations", ["work_id"], :name => "index_work_relations_on_work_id"

  create_table "work_versions", :force => true do |t|
    t.string   "state"
    t.integer  "work_id"
    t.integer  "version"
    t.integer  "composer_id"
    t.string   "title"
    t.string   "main_title",         :limit => 100
    t.string   "lost",               :limit => 1
    t.string   "attr_doubtful",      :limit => 1
    t.string   "tune",               :limit => 100
    t.string   "opus"
    t.string   "instrumentation",    :limit => 110
    t.string   "time_doubtful",      :limit => 1
    t.text     "misc_info"
    t.text     "intern_info_peter"
    t.text     "intern_info_bruce"
    t.string   "oboe",               :limit => 4
    t.string   "country",            :limit => 7
    t.integer  "number",                            :default => 1
    t.integer  "source_id",                         :default => 1
    t.datetime "created_at",                        :default => '2004-06-17 00:00:00', :null => false
    t.string   "done",               :limit => 1
    t.datetime "updated_at",                        :default => '2004-06-17 00:00:00', :null => false
    t.integer  "addition_id"
    t.integer  "version_comment_id"
    t.text     "published"
    t.integer  "year"
    t.integer  "first_year"
    t.integer  "last_year"
    t.string   "oboe_done"
    t.string   "position_title"
    t.boolean  "here",                              :default => false
  end

  add_index "work_versions", ["work_id"], :name => "index_work_versions_on_work_id"

  create_table "works", :force => true do |t|
    t.string   "state",                          :default => "default",             :null => false
    t.integer  "composer_id",                                                       :null => false
    t.string   "title",                                                             :null => false
    t.string   "main_title"
    t.string   "lost",              :limit => 1, :default => "N",                   :null => false
    t.string   "attr_doubtful",     :limit => 1, :default => "N",                   :null => false
    t.string   "tune"
    t.string   "opus"
    t.string   "instrumentation"
    t.string   "time_doubtful",     :limit => 1
    t.text     "misc_info"
    t.text     "intern_info_peter"
    t.text     "intern_info_bruce"
    t.string   "oboe",              :limit => 4, :default => "NNNN",                :null => false
    t.string   "country",           :limit => 7, :default => "NNNNNNN",             :null => false
    t.integer  "number",                         :default => 1,                     :null => false
    t.integer  "source_id",                      :default => 3,                     :null => false
    t.datetime "created_at",                     :default => '2004-06-17 00:00:00', :null => false
    t.string   "done",              :limit => 1, :default => "N",                   :null => false
    t.datetime "updated_at",                     :default => '2004-06-17 00:00:00', :null => false
    t.integer  "version"
    t.text     "published"
    t.integer  "year"
    t.integer  "first_year"
    t.integer  "last_year"
    t.string   "oboe_done"
    t.string   "position_title"
    t.boolean  "here",                           :default => false
  end

  add_index "works", ["composer_id"], :name => "index_works_on_composer_id"
  add_index "works", ["id"], :name => "index_works_on_id", :unique => true
  add_index "works", ["state"], :name => "index_works_on_state"

end
