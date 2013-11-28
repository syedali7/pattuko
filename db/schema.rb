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

ActiveRecord::Schema.define(version: 20131003102013) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "role",                   default: "admin"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "album_images", force: true do |t|
    t.integer  "image_id"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "albums", force: true do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "album_name"
    t.string   "cover_image"
    t.integer  "cover_image_id"
    t.integer  "post_id"
  end

  create_table "all_images", force: true do |t|
    t.string   "file"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "brand"
  end

  create_table "answers", force: true do |t|
    t.string   "answer"
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artist_professions", force: true do |t|
    t.integer  "artist_id"
    t.integer  "artist_type_id"
    t.string   "profession"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight"
  end

  create_table "artist_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "priority"
    t.integer  "points"
  end

  create_table "artists", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "artist_image"
    t.string   "artist_profile_image"
    t.integer  "total_views"
    t.string   "slug"
    t.string   "profession"
    t.date     "dob"
    t.integer  "total_posts",          default: 0
    t.integer  "polls_count"
    t.integer  "mentions_count"
  end

  add_index "artists", ["slug"], name: "index_artists_on_slug", using: :btree

  create_table "claps", force: true do |t|
    t.integer  "user_id"
    t.integer  "clap_id"
    t.string   "clap_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "claps", ["clap_id", "clap_type"], name: "index_claps_on_clap_id_and_clap_type", using: :btree

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "dummy", id: false, force: true do |t|
    t.integer  "id",               default: 0, null: false
    t.integer  "movie_id"
    t.integer  "related_movie_id"
    t.integer  "weight"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "reason"
  end

  create_table "errors", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.text     "description"
  end

  create_table "event_albums", force: true do |t|
    t.integer  "event_id"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "description"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.string   "postable_type"
    t.integer  "postable_id"
    t.integer  "total_posts",    default: 0
    t.string   "slug"
  end

  add_index "events", ["eventable_id", "eventable_type"], name: "index_events_on_eventable_id_and_eventable_type", using: :btree

  create_table "fans", force: true do |t|
    t.integer  "user_id"
    t.integer  "fan_id"
    t.string   "fan_type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "cuid",       limit: 8
  end

  add_index "fans", ["fan_id", "fan_type"], name: "index_fans_on_fan_id_and_fan_type", using: :btree

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "favourable_id"
    t.string   "favourable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "favourites", ["favourable_id", "favourable_type"], name: "index_favourites_on_favourable_id_and_favourable_type", using: :btree

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.integer  "cuid",       limit: 8
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "weight"
    t.boolean  "deleted"
    t.string   "post_image"
    t.string   "post_title"
    t.string   "post_type"
    t.datetime "post_created_on"
    t.date     "created_on"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "image_thumb_height"
    t.boolean  "verified"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "friends", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "friend_id"
  end

  create_table "images", force: true do |t|
    t.string   "image"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "post_id"
    t.integer  "thumb_height"
    t.integer  "medium_height"
  end

  create_table "invitations", force: true do |t|
    t.string   "user_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ip_black_lists", force: true do |t|
    t.string  "ip"
    t.integer "count", default: 0
    t.string  "state", default: "warning"
  end

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "index_likes_on_likeable_id_and_likeable_type", using: :btree

  create_table "mentions", force: true do |t|
    t.integer  "post_id"
    t.integer  "mentionable_id"
    t.string   "mentionable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "index_mentions_on_mentionable_id_and_mentionable_type", using: :btree

  create_table "mercury_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "movie_artists", force: true do |t|
    t.integer  "movie_id"
    t.integer  "artist_id"
    t.integer  "artist_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "movies", force: true do |t|
    t.string   "name"
    t.date     "release_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "year"
    t.integer  "image_id"
    t.integer  "wood_id"
    t.string   "movie_image"
    t.string   "wiki_url"
    t.boolean  "edited"
    t.integer  "thumb_height"
    t.integer  "total_views",    default: 1
    t.string   "slug"
    t.text     "description"
    t.integer  "total_posts",    default: 0
    t.integer  "polls_count"
    t.integer  "mentions_count"
  end

  add_index "movies", ["slug"], name: "index_movies_on_slug", using: :btree

  create_table "news", force: true do |t|
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "image_id"
    t.string   "source_name"
    t.boolean  "edited"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "notification"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "friend_name"
    t.boolean  "seen",         default: false
  end

  create_table "outlinks", force: true do |t|
    t.integer  "user_id"
    t.integer  "cuid",            limit: 8
    t.string   "from_url"
    t.string   "destination_url"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_type"
    t.string   "source"
  end

  create_table "polls", force: true do |t|
    t.integer  "user_id"
    t.string   "poll_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "polling_id"
    t.string   "polling_type"
  end

  add_index "polls", ["polling_id", "polling_type"], name: "index_polls_on_polling_id_and_polling_type", using: :btree

  create_table "post_types", force: true do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "type"
    t.integer  "posting_id"
    t.string   "posting_type"
    t.integer  "user_id"
    t.boolean  "trusted"
    t.string   "slug"
    t.boolean  "post_to_facebook"
    t.boolean  "verified"
    t.date     "release_date"
    t.integer  "draft_comments_count",     default: 0
    t.integer  "published_comments_count", default: 0
    t.integer  "deleted_comments_count",   default: 0
    t.boolean  "ban_flag"
    t.integer  "total_views",              default: 0
    t.boolean  "flaged"
    t.integer  "claps_count",              default: 0
    t.integer  "comments_count",           default: 0
    t.boolean  "trending",                 default: false
  end

  add_index "posts", ["postable_id", "postable_type"], name: "index_posts_on_postable_id_and_postable_type", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "products", force: true do |t|
    t.string   "brand"
    t.string   "title"
    t.integer  "mrp"
    t.string   "price"
    t.text     "offer_note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "product_url"
    t.integer  "style_id"
    t.string   "size"
    t.string   "store"
  end

  create_table "questions", force: true do |t|
    t.string   "question"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "rating"
    t.integer  "cuid",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
  end

  create_table "related_movies", force: true do |t|
    t.integer  "movie_id"
    t.integer  "related_movie_id"
    t.integer  "weight"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "reason"
  end

  add_index "related_movies", ["movie_id"], name: "index_related_movies_on_movie_id", using: :btree

  create_table "related_posts", force: true do |t|
    t.integer  "post_id"
    t.integer  "related_post_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "related_posts", ["post_id"], name: "index_related_posts_on_post_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "rating"
    t.text     "analysis"
    t.string   "punchline"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "movie_image"
    t.integer  "movie_id"
    t.integer  "website_id"
    t.string   "website_url"
    t.integer  "user_id"
    t.integer  "cuid",        limit: 8
  end

  create_table "scores", force: true do |t|
    t.integer  "user_id"
    t.text     "action"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemaps", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "styles", force: true do |t|
    t.string   "title"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_url"
    t.integer  "thumb_height"
    t.integer  "movie_id"
    t.integer  "artist_id"
    t.integer  "event_id"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "theatres", force: true do |t|
    t.string   "theatre"
    t.string   "city"
    t.string   "district"
    t.string   "location"
    t.integer  "seats"
    t.string   "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "weight"
    t.boolean  "deleted"
    t.string   "post_image"
    t.string   "post_title"
    t.string   "post_type"
    t.date     "post_created_on"
    t.date     "created_on"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "image_thumb_height"
    t.string   "cuid"
  end

  create_table "user_agent_black_lists", force: true do |t|
    t.string  "user_agent"
    t.integer "count",      default: 0
    t.string  "state",      default: "warning"
  end

  create_table "user_woods", force: true do |t|
    t.integer  "user_id"
    t.integer  "wood_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "name"
    t.datetime "oauth_expires_at"
    t.string   "oauth_token"
    t.string   "image_url"
    t.string   "profile_url"
    t.integer  "my_comments_count",       default: 0
    t.integer  "draft_comcoms_count",     default: 0
    t.integer  "published_comcoms_count", default: 0
    t.integer  "deleted_comcoms_count",   default: 0
    t.integer  "spam_comcoms_count",      default: 0
    t.string   "slug"
    t.datetime "last_log_in_at"
    t.integer  "score"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  create_table "videos", force: true do |t|
    t.string   "youtube_url"
    t.string   "youtube_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "view_blocks", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watches", force: true do |t|
    t.integer  "watchable_id"
    t.string   "watchable_type"
    t.integer  "user_id"
    t.integer  "cuid",           limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watches", ["watchable_id", "watchable_type"], name: "index_watches_on_watchable_id_and_watchable_type", using: :btree

  create_table "watches_bk", id: false, force: true do |t|
    t.integer  "id",                       default: 0, null: false
    t.integer  "watchable_id"
    t.string   "watchable_type"
    t.integer  "user_id"
    t.integer  "cuid",           limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "websites", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wishes", force: true do |t|
    t.integer  "wish_id"
    t.string   "wish_type"
    t.string   "greeting"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "with_logo_images", force: true do |t|
    t.string   "brand"
    t.string   "sku"
    t.integer  "folder_id"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods", force: true do |t|
    t.string   "wood"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
