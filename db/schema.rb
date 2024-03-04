# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_02_27_002814) do

  create_table "dentists", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "cpf"
    t.date "birthday"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "form_submissions", force: :cascade do |t|
    t.integer "dentist_id", null: false
    t.integer "patient_id", null: false
    t.integer "lab_id", null: false
    t.integer "form_id", null: false
    t.json "form_values"
    t.json "files", default: []
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dentist_id"], name: "index_form_submissions_on_dentist_id"
    t.index ["form_id"], name: "index_form_submissions_on_form_id"
    t.index ["lab_id"], name: "index_form_submissions_on_lab_id"
    t.index ["patient_id"], name: "index_form_submissions_on_patient_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "labs", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "cnpj"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cpf"
    t.string "prontuario"
    t.date "birthday"
    t.integer "dentist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dentist_id"], name: "index_patients_on_dentist_id"
  end

  add_foreign_key "form_submissions", "dentists"
  add_foreign_key "form_submissions", "forms"
  add_foreign_key "form_submissions", "labs"
  add_foreign_key "form_submissions", "patients"
  add_foreign_key "patients", "dentists"
end
