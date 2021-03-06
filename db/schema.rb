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

ActiveRecord::Schema.define(version: 2018_08_23_122939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "candidate_entry_tests", force: :cascade do |t|
    t.bigint "candidate_id"
    t.bigint "entry_test_id"
    t.integer "points"
    t.integer "arrival", default: 1, null: false
    t.text "apology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id", "entry_test_id"], name: "index_candidate_entry_tests_on_candidate_id_and_entry_test_id", unique: true
    t.index ["candidate_id"], name: "index_candidate_entry_tests_on_candidate_id"
    t.index ["entry_test_id"], name: "index_candidate_entry_tests_on_entry_test_id"
  end

  create_table "candidate_interviews", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "interview_id", null: false
    t.string "state"
    t.text "apology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "assigned_hour"
    t.index ["candidate_id"], name: "index_candidate_interviews_on_candidate_id"
    t.index ["interview_id"], name: "index_candidate_interviews_on_interview_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "state", default: 0
    t.date "birth_date"
    t.string "phone"
    t.integer "university"
    t.integer "graduation_year"
    t.string "higher_title"
    t.string "organizations", default: [], array: true
    t.string "suborganizations", default: [], array: true
    t.string "diploma_uid"
    t.boolean "shorter_invitation"
    t.boolean "agreed_limitations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "position"
    t.string "title"
    t.index ["deleted_at"], name: "index_candidates_on_deleted_at"
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "egov_utils_addresses", id: :serial, force: :cascade do |t|
    t.integer "egov_identifier"
    t.string "street"
    t.string "house_number"
    t.string "orientation_number"
    t.string "city"
    t.string "city_part"
    t.string "postcode"
    t.string "district"
    t.string "region"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "egov_utils_groups", force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.string "roles"
    t.string "ldap_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_uid"
  end

  create_table "egov_utils_groups_users", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.index ["group_id"], name: "index_egov_utils_groups_users_on_group_id"
    t.index ["user_id"], name: "index_egov_utils_groups_users_on_user_id"
  end

  create_table "egov_utils_legal_people", force: :cascade do |t|
    t.bigint "person_id"
    t.string "name"
    t.string "ico"
    t.integer "legal_form"
    t.index ["person_id"], name: "index_egov_utils_legal_people_on_person_id"
  end

  create_table "egov_utils_natural_people", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.date "birth_date"
    t.string "external_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "birth_place"
    t.bigint "residence_id"
    t.bigint "person_id"
    t.string "title"
    t.string "higher_title"
    t.index ["person_id"], name: "index_egov_utils_natural_people_on_person_id"
    t.index ["residence_id"], name: "index_egov_utils_natural_people_on_residence_id"
  end

  create_table "egov_utils_people", force: :cascade do |t|
    t.integer "person_type"
    t.string "joid"
    t.bigint "residence_id"
    t.index ["residence_id"], name: "index_egov_utils_people_on_residence_id"
  end

  create_table "egov_utils_users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "mail"
    t.string "password_digest"
    t.string "firstname"
    t.string "lastname"
    t.boolean "active", default: false
    t.string "roles"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "confirmation_code"
    t.boolean "must_change_password"
    t.datetime "password_changed_at"
  end

  create_table "entry_tests", force: :cascade do |t|
    t.datetime "time"
    t.integer "capacity"
    t.integer "place"
    t.integer "points"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "additional_info"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_entry_tests_on_deleted_at"
  end

  create_table "interviews", force: :cascade do |t|
    t.datetime "time"
    t.bigint "region_court_id"
    t.bigint "address_id"
    t.integer "boundary"
    t.datetime "compensatory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["address_id"], name: "index_interviews_on_address_id"
    t.index ["deleted_at"], name: "index_interviews_on_deleted_at"
    t.index ["region_court_id"], name: "index_interviews_on_region_court_id"
  end

  add_foreign_key "candidate_entry_tests", "candidates"
  add_foreign_key "candidate_entry_tests", "entry_tests"
  add_foreign_key "candidate_interviews", "candidates"
  add_foreign_key "candidate_interviews", "interviews"
  add_foreign_key "candidates", "egov_utils_users", column: "user_id"
  add_foreign_key "egov_utils_groups_users", "egov_utils_groups", column: "group_id"
  add_foreign_key "egov_utils_groups_users", "egov_utils_users", column: "user_id"
  add_foreign_key "egov_utils_legal_people", "egov_utils_people", column: "person_id"
  add_foreign_key "egov_utils_natural_people", "egov_utils_addresses", column: "residence_id"
  add_foreign_key "egov_utils_natural_people", "egov_utils_people", column: "person_id"
  add_foreign_key "egov_utils_people", "egov_utils_addresses", column: "residence_id"
  add_foreign_key "interviews", "egov_utils_addresses", column: "address_id"
end
