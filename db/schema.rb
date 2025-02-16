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

ActiveRecord::Schema[7.1].define(version: 2025_02_02_102613) do
  create_schema "divan"

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_controls", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "view_unrelated_articles"
    t.integer "view_article_logs"
    t.integer "view_workflow_transactions"
    t.integer "create_workflow"
    t.integer "alter_article_areas"
    t.integer "alter_article_events"
    t.integer "alter_article_formats"
    t.integer "alter_article_relation_types"
    t.integer "alter_article_sources"
    t.integer "alter_article_types"
    t.integer "alter_keywords"
    t.integer "alter_languages"
    t.integer "alter_profiles"
    t.integer "alter_roles"
    t.integer "alter_duties"
    t.integer "alter_title_types"
    t.integer "alter_content_templates"
    t.integer "alter_section_items"
    t.integer "alter_publishers"
    t.integer "alter_locations"
    t.integer "alter_publish_sources"
    t.integer "alter_access_groups"
    t.integer "alter_profile_groups"
    t.integer "edit_workflow"
    t.integer "edit_roles"
    t.integer "alter_assignments"
    t.integer "edit_assignments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_access_controls_on_role_id"
    t.index ["user_id"], name: "index_access_controls_on_user_id"
  end

  create_table "access_groupings", force: :cascade do |t|
    t.integer "access_group_id"
    t.integer "article_id"
    t.integer "user_id"
    t.boolean "nofity"
    t.boolean "notify"
    t.boolean "notify_automation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_group_id"], name: "index_access_groupings_on_access_group_id"
    t.index ["article_id"], name: "index_access_groupings_on_article_id"
    t.index ["user_id"], name: "index_access_groupings_on_user_id"
  end

  create_table "access_groups", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_groups_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "areaing_histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "article_area_id"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.integer "areaing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["areaing_id"], name: "index_areaing_histories_on_areaing_id"
    t.index ["article_area_id"], name: "index_areaing_histories_on_article_area_id"
    t.index ["article_id"], name: "index_areaing_histories_on_article_id"
    t.index ["user_id"], name: "index_areaing_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_areaing_histories_on_workflow_transition_id"
  end

  create_table "areaings", force: :cascade do |t|
    t.integer "article_area_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_area_id"], name: "index_areaings_on_article_area_id"
    t.index ["article_id"], name: "index_areaings_on_article_id"
  end

  create_table "article_areas", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_article_areas_on_user_id"
  end

  create_table "article_events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_article_events_on_user_id"
  end

  create_table "article_formats", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_article_formats_on_user_id"
  end

  create_table "article_histories", force: :cascade do |t|
    t.string "title"
    t.text "abstract"
    t.text "content"
    t.string "url"
    t.text "document_contents"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "article_id"
    t.integer "workflow_transition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_histories_on_article_id"
    t.index ["user_id"], name: "index_article_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_article_histories_on_workflow_transition_id"
  end

  create_table "article_relation_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.integer "reverse_relation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reverse_relation_id"], name: "index_article_relation_types_on_reverse_relation_id"
    t.index ["user_id"], name: "index_article_relation_types_on_user_id"
  end

  create_table "article_sources", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_article_sources_on_user_id"
  end

  create_table "article_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_article_types_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "abstract"
    t.text "content"
    t.string "url"
    t.string "slug"
    t.integer "workflow_state_id"
    t.integer "content_template_id"
    t.string "document_contents"
    t.text "content_wo_tags"
    t.date "published_at"
    t.integer "access_group_id"
    t.string "description"
    t.text "notes"
    t.string "dimensions"
    t.string "retrieval_number"
    t.text "publish_details"
    t.string "access_for_others"
    t.integer "position"
    t.integer "user_id"
    t.datetime "published_on"
    t.integer "published_via"
    t.string "publish_uuid"
    t.boolean "pdf_generated"
    t.string "trial_uuid"
    t.boolean "archived"
    t.integer "external_id"
    t.integer "publish_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_group_id"], name: "index_articles_on_access_group_id"
    t.index ["content_template_id"], name: "index_articles_on_content_template_id"
    t.index ["external_id"], name: "index_articles_on_external_id"
    t.index ["publish_source_id"], name: "index_articles_on_publish_source_id"
    t.index ["slug"], name: "index_articles_on_slug"
    t.index ["user_id"], name: "index_articles_on_user_id"
    t.index ["workflow_state_id"], name: "index_articles_on_workflow_state_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "assigner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigner_id"], name: "index_assignments_on_assigner_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "carriers", force: :cascade do |t|
    t.integer "source_workflow_state_id"
    t.integer "target_workflow_state_id"
    t.string "rules"
    t.integer "user_id"
    t.boolean "done"
    t.integer "timer"
    t.integer "voting_condition"
    t.integer "trials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_workflow_state_id"], name: "index_carriers_on_source_workflow_state_id"
    t.index ["target_workflow_state_id"], name: "index_carriers_on_target_workflow_state_id"
    t.index ["user_id"], name: "index_carriers_on_user_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "user_id"
    t.string "comment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "content_templates", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_content_templates_on_user_id"
  end

  create_table "contribution_histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "role_id"
    t.integer "duty_id"
    t.integer "profile_id"
    t.integer "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.integer "contribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_contribution_histories_on_article_id"
    t.index ["contribution_id"], name: "index_contribution_histories_on_contribution_id"
    t.index ["duty_id"], name: "index_contribution_histories_on_duty_id"
    t.index ["profile_id"], name: "index_contribution_histories_on_profile_id"
    t.index ["role_id"], name: "index_contribution_histories_on_role_id"
    t.index ["user_id"], name: "index_contribution_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_contribution_histories_on_workflow_transition_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.integer "article_id"
    t.integer "role_id"
    t.integer "duty_id"
    t.integer "profile_id"
    t.boolean "sign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_contributions_on_article_id"
    t.index ["duty_id"], name: "index_contributions_on_duty_id"
    t.index ["profile_id"], name: "index_contributions_on_profile_id"
    t.index ["role_id"], name: "index_contributions_on_role_id"
  end

  create_table "dating_histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "article_event_id"
    t.date "event_date"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.integer "dating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_event_id"], name: "index_dating_histories_on_article_event_id"
    t.index ["article_id"], name: "index_dating_histories_on_article_id"
    t.index ["dating_id"], name: "index_dating_histories_on_dating_id"
    t.index ["user_id"], name: "index_dating_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_dating_histories_on_workflow_transition_id"
  end

  create_table "datings", force: :cascade do |t|
    t.integer "article_event_id"
    t.integer "article_id"
    t.date "event_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_event_id"], name: "index_datings_on_article_event_id"
    t.index ["article_id"], name: "index_datings_on_article_id"
  end

  create_table "duties", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_duties_on_user_id"
  end

  create_table "formating_histories", force: :cascade do |t|
    t.integer "article_format_id"
    t.integer "article_id"
    t.integer "user_id"
    t.string "revision_number"
    t.integer "workflow_state_id"
    t.integer "formating_id"
    t.integer "workflow_transition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_format_id"], name: "index_formating_histories_on_article_format_id"
    t.index ["article_id"], name: "index_formating_histories_on_article_id"
    t.index ["formating_id"], name: "index_formating_histories_on_formating_id"
    t.index ["user_id"], name: "index_formating_histories_on_user_id"
    t.index ["workflow_state_id"], name: "index_formating_histories_on_workflow_state_id"
    t.index ["workflow_transition_id"], name: "index_formating_histories_on_workflow_transition_id"
  end

  create_table "formatings", force: :cascade do |t|
    t.integer "article_format_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_format_id"], name: "index_formatings_on_article_format_id"
    t.index ["article_id"], name: "index_formatings_on_article_id"
  end

  create_table "home_settings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "pp"
    t.string "sort"
    t.integer "workflow_state"
    t.integer "workflow"
    t.integer "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_home_settings_on_user_id"
  end

  create_table "interconnects", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uuid"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_interconnects_on_user_id"
  end

  create_table "involvements", force: :cascade do |t|
    t.integer "article_id"
    t.integer "publisher_id"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_involvements_on_article_id"
    t.index ["publisher_id"], name: "index_involvements_on_publisher_id"
  end

  create_table "journals", force: :cascade do |t|
    t.string "title"
    t.string "vol"
    t.string "no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_keywords_on_user_id"
  end

  create_table "kinship_histories", force: :cascade do |t|
    t.integer "user_id"
    t.integer "kin_id"
    t.integer "article_id"
    t.integer "article_relation_type_id"
    t.string "revision_number"
    t.integer "workflow_transition_id"
    t.integer "kinship_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_kinship_histories_on_article_id"
    t.index ["article_relation_type_id"], name: "index_kinship_histories_on_article_relation_type_id"
    t.index ["kin_id"], name: "index_kinship_histories_on_kin_id"
    t.index ["kinship_id"], name: "index_kinship_histories_on_kinship_id"
    t.index ["user_id"], name: "index_kinship_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_kinship_histories_on_workflow_transition_id"
  end

  create_table "kinships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "kin_id"
    t.integer "article_relation_type_id"
    t.integer "article_id"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_kinships_on_article_id"
    t.index ["article_relation_type_id"], name: "index_kinships_on_article_relation_type_id"
    t.index ["kin_id"], name: "index_kinships_on_kin_id"
    t.index ["user_id"], name: "index_kinships_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_languages_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.float "longitude"
    t.float "latidue"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "sender_id"
    t.integer "urgency"
    t.integer "status"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_messages_on_parent_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "messagings", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "message_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_messagings_on_message_id"
    t.index ["recipient_id"], name: "index_messagings_on_recipient_id"
  end

  create_table "mirorrs", force: :cascade do |t|
    t.integer "source_state"
    t.integer "target_state"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mirorrs_on_user_id"
  end

  create_table "note_templates", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_note_templates_on_user_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "article_sent"
    t.boolean "article_received"
    t.boolean "article_refunded"
    t.boolean "article_refunded_received"
    t.boolean "article_comment"
    t.boolean "article_vote"
    t.boolean "access_grouping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "notifiable_id"
    t.string "notifiable_type"
    t.integer "user_id"
    t.string "notification_type"
    t.integer "emmiter_id"
    t.text "custom_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emmiter_id"], name: "index_notifications_on_emmiter_id"
    t.index ["notifiable_id"], name: "index_notifications_on_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "notings", force: :cascade do |t|
    t.integer "note_template_id"
    t.integer "article_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_notings_on_article_id"
    t.index ["note_template_id"], name: "index_notings_on_note_template_id"
    t.index ["user_id"], name: "index_notings_on_user_id"
  end

  create_table "originating_histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "article_source_id"
    t.integer "originating_id"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_originating_histories_on_article_id"
    t.index ["article_source_id"], name: "index_originating_histories_on_article_source_id"
    t.index ["originating_id"], name: "index_originating_histories_on_originating_id"
    t.index ["user_id"], name: "index_originating_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_originating_histories_on_workflow_transition_id"
  end

  create_table "originatings", force: :cascade do |t|
    t.integer "article_id"
    t.integer "article_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_originatings_on_article_id"
    t.index ["article_source_id"], name: "index_originatings_on_article_source_id"
  end

  create_table "profile_groupings", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "profile_group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_group_id"], name: "index_profile_groupings_on_profile_group_id"
    t.index ["profile_id"], name: "index_profile_groupings_on_profile_id"
    t.index ["user_id"], name: "index_profile_groupings_on_user_id"
  end

  create_table "profile_groups", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.integer "workflow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profile_groups_on_user_id"
    t.index ["workflow_id"], name: "index_profile_groups_on_workflow_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "surename"
    t.integer "user_id"
    t.string "phone_number"
    t.string "cellphone_number"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "email"
    t.string "stage_name"
    t.string "signature_file_name"
    t.string "signature_content_type"
    t.bigint "signature_file_size"
    t.datetime "signature_updated_at"
    t.integer "personnel_code"
    t.string "dabir_personnel_id"
    t.string "dabir_department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dabir_department_id"], name: "index_profiles_on_dabir_department_id"
    t.index ["dabir_personnel_id"], name: "index_profiles_on_dabir_personnel_id"
    t.index ["email"], name: "index_profiles_on_email"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "publications", force: :cascade do |t|
    t.integer "article_id"
    t.integer "publisher_id"
    t.date "publication_date"
    t.string "pp"
    t.string "vol"
    t.integer "location_id"
    t.integer "publish_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_publications_on_article_id"
    t.index ["location_id"], name: "index_publications_on_location_id"
    t.index ["publish_source_id"], name: "index_publications_on_publish_source_id"
    t.index ["publisher_id"], name: "index_publications_on_publisher_id"
  end

  create_table "publish_sources", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "publisher_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_publish_sources_on_publisher_id"
    t.index ["user_id"], name: "index_publish_sources_on_user_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "user_id"
    t.integer "organization_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_publishers_on_user_id"
  end

  create_table "role_accesses", force: :cascade do |t|
    t.integer "role_id"
    t.integer "access_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_group_id"], name: "index_role_accesses_on_access_group_id"
    t.index ["role_id"], name: "index_role_accesses_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "abr"
    t.integer "user_id"
    t.boolean "start_point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "section_items", force: :cascade do |t|
    t.integer "section_id"
    t.string "item_name"
    t.string "title"
    t.string "description"
    t.integer "user_id"
    t.string "klass_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_section_items_on_section_id"
    t.index ["user_id"], name: "index_section_items_on_user_id"
  end

  create_table "sectionings", force: :cascade do |t|
    t.integer "section_id"
    t.integer "section_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_sectionings_on_section_id"
    t.index ["section_item_id"], name: "index_sectionings_on_section_item_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "workflow_id"
    t.integer "user_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sections_on_user_id"
    t.index ["workflow_id"], name: "index_sections_on_workflow_id"
  end

  create_table "speaking_histories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "language_id"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.integer "speaking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_speaking_histories_on_article_id"
    t.index ["language_id"], name: "index_speaking_histories_on_language_id"
    t.index ["speaking_id"], name: "index_speaking_histories_on_speaking_id"
    t.index ["user_id"], name: "index_speaking_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_speaking_histories_on_workflow_transition_id"
  end

  create_table "speakings", force: :cascade do |t|
    t.integer "language_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_speakings_on_article_id"
    t.index ["language_id"], name: "index_speakings_on_language_id"
  end

  create_table "ssos", force: :cascade do |t|
    t.string "utid"
    t.string "uuid"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_pages", force: :cascade do |t|
    t.integer "workflow_state_id"
    t.boolean "item_title"
    t.boolean "item_titlings"
    t.boolean "item_abstract"
    t.boolean "item_url"
    t.boolean "item_keywords"
    t.boolean "item_datings"
    t.boolean "item_typings"
    t.boolean "item_speakings"
    t.boolean "item_formatings"
    t.boolean "item_contributions"
    t.boolean "item_kinships"
    t.boolean "item_originatings"
    t.boolean "item_content"
    t.boolean "item_upload"
    t.string "uuid"
    t.boolean "item_areaings"
    t.boolean "item_publications"
    t.boolean "item_notes"
    t.boolean "item_dimensions"
    t.boolean "item_retrieval_number"
    t.boolean "item_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_state_id"], name: "index_state_pages_on_workflow_state_id"
  end

  create_table "tagging_histories", force: :cascade do |t|
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "target_id"
    t.string "target_type"
    t.integer "user_id"
    t.string "revision_number"
    t.integer "article_id"
    t.integer "workflow_transition_id"
    t.integer "tagging_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_tagging_histories_on_article_id"
    t.index ["taggable_id"], name: "index_tagging_histories_on_taggable_id"
    t.index ["tagging_id"], name: "index_tagging_histories_on_tagging_id"
    t.index ["target_id"], name: "index_tagging_histories_on_target_id"
    t.index ["user_id"], name: "index_tagging_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_tagging_histories_on_workflow_transition_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["target_id"], name: "index_taggings_on_target_id"
  end

  create_table "title_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_title_types_on_user_id"
  end

  create_table "titlings", force: :cascade do |t|
    t.integer "title_type_id"
    t.integer "article_id"
    t.integer "status"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_titlings_on_article_id"
    t.index ["title_type_id"], name: "index_titlings_on_title_type_id"
  end

  create_table "typing_histories", force: :cascade do |t|
    t.integer "article_type_id"
    t.integer "article_id"
    t.integer "typing_id"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_typing_histories_on_article_id"
    t.index ["article_type_id"], name: "index_typing_histories_on_article_type_id"
    t.index ["typing_id"], name: "index_typing_histories_on_typing_id"
    t.index ["user_id"], name: "index_typing_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_typing_histories_on_workflow_transition_id"
  end

  create_table "typings", force: :cascade do |t|
    t.integer "article_type_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_typings_on_article_id"
    t.index ["article_type_id"], name: "index_typings_on_article_type_id"
  end

  create_table "upload_histories", force: :cascade do |t|
    t.string "uploadable_type"
    t.integer "uploadable_id"
    t.string "token"
    t.string "attachment_type"
    t.string "revision_number"
    t.integer "user_id"
    t.integer "workflow_transition_id"
    t.integer "speaking_id"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer "upload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speaking_id"], name: "index_upload_histories_on_speaking_id"
    t.index ["upload_id"], name: "index_upload_histories_on_upload_id"
    t.index ["uploadable_id"], name: "index_upload_histories_on_uploadable_id"
    t.index ["user_id"], name: "index_upload_histories_on_user_id"
    t.index ["workflow_transition_id"], name: "index_upload_histories_on_workflow_transition_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "uploadable_type"
    t.integer "uploadable_id"
    t.string "token"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "attachment_type"
    t.string "title"
    t.text "detail"
    t.integer "user_id"
    t.boolean "only_index"
    t.boolean "printable"
    t.boolean "summable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploadable_id"], name: "index_uploads_on_uploadable_id"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "current_role_id"
    t.string "utid"
    t.string "name"
    t.string "surename"
    t.integer "new_utid"
    t.text "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_role_id"], name: "index_users_on_current_role_id"
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "voting_id"
    t.integer "outcome"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_votes_on_article_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["voting_id"], name: "index_votes_on_voting_id"
  end

  create_table "votings", force: :cascade do |t|
    t.integer "votable_id"
    t.string "votable_type"
    t.integer "deadline"
    t.integer "voting_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id"], name: "index_votings_on_votable_id"
  end

  create_table "word_templates", force: :cascade do |t|
    t.string "title"
    t.integer "workflow_id"
    t.integer "user_id"
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_word_templates_on_user_id"
    t.index ["workflow_id"], name: "index_word_templates_on_workflow_id"
  end

  create_table "workflow_role_accesses", force: :cascade do |t|
    t.integer "workflow_id"
    t.integer "role_id"
    t.boolean "own_article_traceable"
    t.boolean "other_articles_traceable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_workflow_role_accesses_on_role_id"
    t.index ["workflow_id"], name: "index_workflow_role_accesses_on_workflow_id"
  end

  create_table "workflow_states", force: :cascade do |t|
    t.string "title"
    t.integer "workflow_id"
    t.integer "node_id"
    t.text "editable"
    t.integer "refundable"
    t.integer "commentable"
    t.integer "start_point"
    t.integer "end_point"
    t.integer "role_id"
    t.integer "votable"
    t.integer "publishable"
    t.integer "notifiable"
    t.boolean "deleted"
    t.integer "default_state_page"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["node_id"], name: "index_workflow_states_on_node_id"
    t.index ["role_id"], name: "index_workflow_states_on_role_id"
    t.index ["workflow_id"], name: "index_workflow_states_on_workflow_id"
  end

  create_table "workflow_transitions", force: :cascade do |t|
    t.integer "workflow_id"
    t.integer "from_state_id"
    t.integer "to_state_id"
    t.text "message"
    t.integer "user_id"
    t.integer "role_id"
    t.integer "transition_type"
    t.integer "article_id"
    t.string "revision_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_workflow_transitions_on_article_id"
    t.index ["from_state_id"], name: "index_workflow_transitions_on_from_state_id"
    t.index ["role_id"], name: "index_workflow_transitions_on_role_id"
    t.index ["to_state_id"], name: "index_workflow_transitions_on_to_state_id"
    t.index ["user_id"], name: "index_workflow_transitions_on_user_id"
    t.index ["workflow_id"], name: "index_workflow_transitions_on_workflow_id"
  end

  create_table "workflows", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.string "graph_data"
    t.string "nodes"
    t.string "edges"
    t.integer "start_node_id"
    t.integer "admin_id"
    t.integer "moderator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_workflows_on_admin_id"
    t.index ["moderator_id"], name: "index_workflows_on_moderator_id"
    t.index ["start_node_id"], name: "index_workflows_on_start_node_id"
    t.index ["user_id"], name: "index_workflows_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
