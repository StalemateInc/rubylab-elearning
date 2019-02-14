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

ActiveRecord::Schema.define(version: 2019_02_14_180726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "answer_lists", force: :cascade do |t|
    t.hstore "answers", null: false
    t.string "correct_answers", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "question_id"
    t.index ["question_id"], name: "index_answer_lists_on_question_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "filename", null: false
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "completion_record_id"
    t.index ["completion_record_id"], name: "index_certificates_on_completion_record_id"
    t.index ["course_id"], name: "index_certificates_on_course_id"
  end

  create_table "completion_records", force: :cascade do |t|
    t.integer "score", null: false
    t.integer "status", null: false
    t.datetime "date"
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_completion_records_on_course_id"
    t.index ["user_id"], name: "index_completion_records_on_user_id"
  end

  create_table "course_accesses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_accesses_on_course_id"
    t.index ["user_id"], name: "index_course_accesses_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.integer "difficulty", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "status", default: 0
    t.integer "visibility", default: 0
  end

  create_table "favorite_courses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_favorite_courses_on_course_id"
    t.index ["user_id"], name: "index_favorite_courses_on_user_id"
  end

  create_table "impersonation_histories", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.bigint "impersonator_id"
    t.bigint "target_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["impersonator_id"], name: "index_impersonation_histories_on_impersonator_id"
    t.index ["target_user_id"], name: "index_impersonation_histories_on_target_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  create_table "join_requests", force: :cascade do |t|
    t.text "comment"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_join_requests_on_organization_id"
    t.index ["user_id"], name: "index_join_requests_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.boolean "org_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "ownerships", force: :cascade do |t|
    t.string "ownable_type"
    t.bigint "ownable_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_ownerships_on_course_id"
    t.index ["ownable_type", "ownable_id"], name: "index_ownerships_on_ownable_type_and_ownable_id"
  end

  create_table "pages", force: :cascade do |t|
    t.text "html", null: false
    t.text "css", null: false
    t.bigint "previous_page_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_pages_on_course_id"
    t.index ["previous_page_id"], name: "index_pages_on_previous_page_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "await_check", default: false
    t.bigint "page_id"
    t.index ["course_id"], name: "index_participations_on_course_id"
    t.index ["page_id"], name: "index_participations_on_page_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "surname"
    t.string "nickname"
    t.string "address"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nickname"], name: "index_profiles_on_nickname", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content", null: false
    t.integer "type"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_questions_on_page_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.string "answer", null: false
    t.bigint "question_id"
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_answers_on_course_id"
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "ownerships", "courses"
  add_foreign_key "participations", "courses"
  add_foreign_key "participations", "users"
  add_foreign_key "profiles", "users"
end
