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

ActiveRecord::Schema.define(version: 20160406015629) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["created_at"], name: "index_activities_on_created_at", using: :btree
  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "alarms", force: true do |t|
    t.integer  "member_id"
    t.datetime "time"
    t.string   "description"
    t.string   "state",       default: "new"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ahead"
  end

  add_index "alarms", ["owner_type", "owner_id"], name: "index_alarms_on_owner_type_and_owner_id", using: :btree
  add_index "alarms", ["state"], name: "index_alarms_on_state", using: :btree
  add_index "alarms", ["time"], name: "index_alarms_on_time", using: :btree

  create_table "bank_accounts", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "bank_accounts", ["owner_id"], name: "index_bank_accounts_on_owner_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "email"
    t.string   "qq"
    t.string   "from"
    t.text     "introduction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "member_id"
    t.string   "workflow_state"
    t.boolean  "is_agent",           default: false
    t.string   "agent_type"
    t.integer  "last_member_id"
    t.datetime "last_updated_at"
    t.boolean  "pool",               default: false
    t.string   "vip_level",          default: "normal"
    t.string   "shop_type"
    t.integer  "historical_rejects", default: 0
    t.string   "wechat_number"
    t.integer  "level"
    t.string   "province"
    t.string   "city"
  end

  add_index "customers", ["created_at"], name: "index_customers_on_created_at", using: :btree
  add_index "customers", ["last_member_id"], name: "index_customers_on_last_member_id", using: :btree
  add_index "customers", ["last_updated_at"], name: "index_customers_on_last_updated_at", using: :btree
  add_index "customers", ["member_id"], name: "index_customers_on_member_id", using: :btree
  add_index "customers", ["province", "city"], name: "index_customers_on_province_and_city", using: :btree
  add_index "customers", ["tel"], name: "index_customers_on_tel", using: :btree
  add_index "customers", ["workflow_state"], name: "index_customers_on_workflow_state", using: :btree

  create_table "customers_zones", force: true do |t|
    t.integer "zone_id"
    t.integer "customer_id"
  end

  create_table "ddb_accounts", force: true do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.string   "email"
    t.string   "slug"
    t.string   "title"
    t.integer  "member_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id"
    t.string   "phone"
  end

  add_index "ddb_accounts", ["customer_id"], name: "index_ddb_accounts_on_customer_id", using: :btree
  add_index "ddb_accounts", ["member_id"], name: "index_ddb_accounts_on_member_id", using: :btree

  create_table "departments", force: true do |t|
    t.string   "name"
    t.integer  "members_count", default: 0
    t.integer  "items_count",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manager_id"
  end

  create_table "faqs", force: true do |t|
    t.string   "title"
    t.integer  "member_id"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faqs", ["member_id"], name: "index_faqs_on_member_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.decimal  "amount",           precision: 10, scale: 2
    t.integer  "saler_id"
    t.integer  "product_id"
    t.text     "description"
    t.integer  "customer_id"
    t.integer  "ddb_account_id"
    t.string   "time_gap"
    t.integer  "applier_id"
    t.integer  "approver_id"
    t.string   "workflow_state"
    t.datetime "deleted_at"
    t.datetime "transaction_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_balance_due",                           default: false
    t.decimal  "balance_due",      precision: 8,  scale: 2
    t.datetime "due_date"
    t.integer  "due_item_id"
    t.integer  "order_id"
    t.integer  "bank_account_id"
    t.integer  "partner_id"
    t.string   "invoice"
    t.integer  "department_id"
    t.string   "reason"
    t.float    "rebate_amount"
  end

  add_index "items", ["applier_id"], name: "index_items_on_applier_id", using: :btree
  add_index "items", ["approver_id"], name: "index_items_on_approver_id", using: :btree
  add_index "items", ["customer_id"], name: "index_items_on_customer_id", using: :btree
  add_index "items", ["ddb_account_id"], name: "index_items_on_ddb_account_id", using: :btree
  add_index "items", ["department_id"], name: "index_items_on_department_id", using: :btree
  add_index "items", ["order_id"], name: "index_items_on_order_id", using: :btree
  add_index "items", ["partner_id"], name: "index_items_on_partner_id", using: :btree
  add_index "items", ["product_id"], name: "index_items_on_product_id", using: :btree
  add_index "items", ["saler_id"], name: "index_items_on_saler_id", using: :btree

  create_table "member_customer_histories", force: true do |t|
    t.integer  "member_id"
    t.integer  "customer_id"
    t.string   "last_state"
    t.datetime "last_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "member_customer_histories", ["customer_id"], name: "index_member_customer_histories_on_customer_id", using: :btree
  add_index "member_customer_histories", ["member_id"], name: "index_member_customer_histories_on_member_id", using: :btree

  create_table "members", force: true do |t|
    t.string   "email",                                            default: "",    null: false
    t.string   "encrypted_password",                               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                                  default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "deleted_at"
    t.integer  "customers_count",                                  default: 0
    t.string   "name"
    t.decimal  "customer_share_threshold", precision: 4, scale: 2, default: 0.05
    t.boolean  "can_accept_new",                                   default: true
    t.boolean  "is_blocked",                                       default: false
    t.integer  "department_id"
    t.string   "bank_card_type"
    t.string   "bank_card_number"
  end

  add_index "members", ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true, using: :btree
  add_index "members", ["created_at"], name: "index_members_on_created_at", using: :btree
  add_index "members", ["department_id"], name: "index_members_on_department_id", using: :btree
  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree

  create_table "members_roles", id: false, force: true do |t|
    t.integer "member_id"
    t.integer "role_id"
  end

  add_index "members_roles", ["member_id", "role_id"], name: "index_members_roles_on_member_id_and_role_id", using: :btree

  create_table "navigations", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "content"
    t.integer  "customer_id"
    t.integer  "member_id"
    t.string   "from_state"
    t.string   "to_state"
    t.string   "event"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.datetime "visit_at"
    t.string   "visit_reason"
  end

  add_index "notes", ["created_at"], name: "index_notes_on_created_at", using: :btree
  add_index "notes", ["customer_id"], name: "index_notes_on_customer_id", using: :btree
  add_index "notes", ["member_id"], name: "index_notes_on_member_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "human_order_id"
    t.integer  "note_id"
    t.decimal  "amount",         precision: 8, scale: 2
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "wechat_number"
    t.string   "pos"
    t.integer  "visit_note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["created_at"], name: "index_people_on_created_at", using: :btree
  add_index "people", ["visit_note_id"], name: "index_people_on_visit_note_id", using: :btree

  create_table "phones", force: true do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "number"
    t.string  "province"
    t.string  "city"
    t.string  "areacode"
    t.string  "zip"
    t.string  "company"
    t.string  "card"
  end

  add_index "phones", ["number"], name: "index_phones_on_number", using: :btree
  add_index "phones", ["owner_id"], name: "index_phones_on_owner_id", using: :btree
  add_index "phones", ["province", "city"], name: "index_phones_on_province_and_city", using: :btree

  create_table "product_associations", force: true do |t|
    t.integer  "product_type_id"
    t.integer  "product_associate_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: true do |t|
    t.string  "name"
    t.float   "amount_condition"
    t.integer "order_num_condition"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.decimal  "price",                precision: 8, scale: 2
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_type"
    t.string   "rebate_way"
    t.float    "rebate_value"
    t.float    "rebate_high_value"
    t.float    "rebate_manager_value"
  end

  create_table "relationships", force: true do |t|
    t.integer  "manager_id"
    t.integer  "department_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["department_id"], name: "index_relationships_on_department_id", using: :btree
  add_index "relationships", ["manager_id"], name: "index_relationships_on_manager_id", using: :btree
  add_index "relationships", ["member_id"], name: "index_relationships_on_member_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "system_configs", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_records", force: true do |t|
    t.integer  "product_id"
    t.integer  "member_id"
    t.integer  "customer_id"
    t.decimal  "amount",      precision: 8, scale: 2
    t.integer  "note_id"
    t.integer  "saler_id"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transaction_records", ["customer_id"], name: "index_transaction_records_on_customer_id", using: :btree
  add_index "transaction_records", ["member_id"], name: "index_transaction_records_on_member_id", using: :btree
  add_index "transaction_records", ["note_id"], name: "index_transaction_records_on_note_id", using: :btree
  add_index "transaction_records", ["product_id"], name: "index_transaction_records_on_product_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "zones", force: true do |t|
    t.string   "name"
    t.string   "zone_type"
    t.integer  "parent_zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
