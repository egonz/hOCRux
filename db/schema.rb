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

ActiveRecord::Schema.define(:version => 20120325062107) do

  create_table "beta_keys", :force => true do |t|
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "authors"
    t.string   "publisher"
    t.date     "published_date"
    t.text     "description"
    t.integer  "isbn"
    t.integer  "isbn_10"
    t.integer  "isbn_13"
    t.integer  "page_count"
    t.string   "print_type"
    t.string   "categories"
    t.integer  "average_rating"
    t.integer  "ratings_count"
    t.string   "language"
    t.string   "preview_link"
    t.string   "info_link"
    t.string   "image_link"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "edocs", :force => true do |t|
    t.integer  "user_book_id"
    t.string   "file_name"
    t.string   "doc_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "libraries", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "user_book_id"
    t.string   "processed_image"
    t.boolean  "processed"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "image"
    t.string   "pdf_file"
    t.integer  "page_no"
    t.boolean  "last_page"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "subscribers", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_books", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "library_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "auto_gen_pdf"
    t.boolean  "email_doc"
    t.integer  "total_pages"
    t.integer  "width"
    t.integer  "height"
    t.string   "hash_key"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "facebook_id"
    t.boolean  "verified"
    t.boolean  "admin"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "beta_key"
  end

end
