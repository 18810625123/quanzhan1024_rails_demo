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

ActiveRecord::Schema[7.0].define(version: 2022_07_05_141237) do
  create_table "awards", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "受益用户id"
    t.decimal "score", precision: 10, scale: 2, default: "0.0", null: false, comment: "奖励学币"
    t.integer "state", limit: 1, default: 1, null: false, comment: "奖励发放状态 1 已发放 0 未发放"
    t.string "category", default: "0", null: false, comment: "奖励类型 UserRegister UserOrder UserRead CurriculumCatalogOrder"
    t.integer "o_id", default: 0, null: false
    t.string "o_type", limit: 30, default: "", null: false, comment: "奖励类型 User Order CurriculumCatalogOrder"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["o_id", "o_type"], name: "index_awards_on_o_id_and_o_type"
    t.index ["o_type"], name: "index_awards_on_o_type"
    t.index ["score"], name: "index_awards_on_score"
    t.index ["user_id"], name: "index_awards_on_user_id"
  end

  create_table "blogs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", limit: 100, default: "", null: false, comment: "标题"
    t.integer "user_id", null: false
    t.text "content", null: false, comment: "文字内容"
    t.string "imgs", limit: 1000, default: "", null: false, comment: "图片(多个以,分隔）"
    t.string "video_ids", limit: 50, default: "", null: false, comment: "视频(多个以,分隔）"
    t.string "flags", default: "", null: false, comment: "自定义标签(多个以,分隔）"
    t.string "category", limit: 20, default: "text", null: false, comment: "文章类型 text md img"
    t.string "md_preview_theme", limit: 20, default: "cyanosis", null: false
    t.integer "state", limit: 1, default: 1, null: false, comment: "当前状态 1 正常 0 删除"
    t.integer "like_count", default: 0, null: false, comment: "被点赞次数"
    t.integer "share_count", default: 0, null: false, comment: "被分享次数"
    t.integer "comment_count", default: 0, null: false, comment: "被评论次数"
    t.integer "read_count", default: 0, null: false, comment: "被阅读次数"
    t.string "type", limit: 30, default: "article", null: false, comment: "类型 文章article 动态dynamic"
    t.integer "o_id", null: false
    t.string "o_type", null: false, comment: "blog的主体类型 Curriculum CurriculumCatalog"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["category"], name: "index_blogs_on_category"
    t.index ["flags"], name: "index_blogs_on_flags"
    t.index ["state"], name: "index_blogs_on_state"
    t.index ["title"], name: "index_blogs_on_title"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.string "from_type", null: false, comment: "User Group"
    t.string "to_type", null: false, comment: "User Group"
    t.string "content", null: false
    t.integer "state", limit: 1, default: 0, null: false, comment: "未读 0  已读 1"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["from_id", "from_type", "state"], name: "index_messages_on_from_id_and_from_type_and_state"
    t.index ["to_id", "to_type", "state"], name: "index_messages_on_to_id_and_to_type_and_state"
  end

  create_table "suggests", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "content", limit: 500, default: "", null: false
    t.string "imgs", limit: 500, default: "", null: false
    t.string "ip", limit: 100, null: false
    t.integer "ua_info_id", default: 0, null: false
    t.string "device_id", limit: 40, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["content"], name: "index_suggests_on_content"
    t.index ["user_id"], name: "index_suggests_on_user_id"
  end

  create_table "user_cares", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "o_id", null: false
    t.string "o_type", default: "User", null: false
    t.integer "state", limit: 1, default: 1, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["o_id", "o_type", "state", "created_at"], name: "fans"
    t.index ["user_id", "o_id"], name: "care_user?"
    t.index ["user_id", "o_type", "state", "created_at"], name: "cares"
  end

  create_table "user_comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "o_id", null: false
    t.string "o_type", null: false, comment: "评论的主体类型  Blog UserComment Curriculum CurriculumCatalog"
    t.string "content", limit: 500, default: "", null: false
    t.integer "like_count", default: 0, null: false
    t.integer "comment_count", default: 0, null: false
    t.integer "state", limit: 1, default: 1, null: false
    t.integer "o_user_id", null: false, comment: "被评论的用户（统计用）"
    t.string "parent_o_info", limit: 30, default: "", null: false, comment: "父评信息 o_type:o_id"
    t.integer "root_comment_id", default: 0, null: false, comment: "根评id"
    t.string "ip", limit: 60, null: false
    t.integer "ua_info_id", default: 0, null: false
    t.string "device_id", limit: 40, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["ip"], name: "index_user_comments_on_ip"
    t.index ["o_id", "o_type", "state"], name: "comments"
    t.index ["o_user_id"], name: "index_user_comments_on_o_user_id"
    t.index ["parent_o_info"], name: "index_user_comments_on_parent_o_info"
    t.index ["ua_info_id"], name: "index_user_comments_on_ua_info_id"
    t.index ["user_id"], name: "index_user_comments_on_user_id"
  end

  create_table "user_likes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "点赞的用户"
    t.integer "o_id", null: false
    t.string "o_type", null: false, comment: "点赞的主体类型  Blog UserComment Curriculum CurriculumCatalog"
    t.integer "state", limit: 1, default: 1, null: false
    t.integer "o_user_id", null: false, comment: "被点赞的用户（统计用）"
    t.string "parent_o_info", limit: 30, default: "", null: false, comment: "父评信息 o_type:o_id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["o_id"], name: "index_user_likes_on_o_id"
    t.index ["o_user_id", "state"], name: "orders"
    t.index ["parent_o_info"], name: "index_user_likes_on_parent_o_info"
    t.index ["user_id"], name: "index_user_likes_on_user_id"
  end

  create_table "user_login_histories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip", limit: 100, default: "", null: false
    t.integer "ua_info_id", default: 0, null: false
    t.string "note", default: "", null: false
    t.string "device_id", limit: 40, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["device_id"], name: "index_user_login_histories_on_device_id"
    t.index ["ip"], name: "index_user_login_histories_on_ip"
    t.index ["user_id"], name: "index_user_login_histories_on_user_id"
  end

  create_table "user_register_infos", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "device_id", limit: 40, default: "", null: false, comment: "注册时的设备id"
    t.integer "ua_info_id", default: 0, null: false
    t.string "ip", limit: 100, default: "", null: false, comment: "注册时的IP"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["device_id"], name: "index_user_register_infos_on_device_id"
    t.index ["ip"], name: "index_user_register_infos_on_ip"
    t.index ["ua_info_id"], name: "index_user_register_infos_on_ua_info_id"
    t.index ["user_id"], name: "index_user_register_infos_on_user_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "uid", limit: 20, null: false, comment: "用户登录用UID"
    t.string "phone", limit: 11, comment: "用户登录用手机号"
    t.string "unionid", limit: 100, comment: "用户微信unionid"
    t.string "openid", limit: 100, comment: "用户微信openid"
    t.string "wx_xcx_openid", limit: 100, comment: "用户微信openid"
    t.string "email", limit: 50, comment: "用户登录用邮箱"
    t.integer "fans_count", default: 0, null: false, comment: "用户粉丝数"
    t.integer "cares_count", default: 0, null: false, comment: "用户关注数"
    t.integer "order_count", default: 0, null: false, comment: "用户order数"
    t.integer "like_count", default: 0, null: false, comment: "用户收到点赞数"
    t.integer "not_read_count", default: 0, null: false, comment: "未读消息"
    t.string "invite_code", limit: 6, comment: "我的邀请码"
    t.integer "invite_user_id", default: 0, null: false, comment: "邀请注册的用户"
    t.integer "invite_share_log_id", default: 0, null: false, comment: "邀请注册关系建立的分享访问日志id"
    t.string "nick_name", limit: 20, default: "", null: false, comment: "昵称"
    t.string "info", limit: 25, default: "一行的简介", null: false, comment: "短简介"
    t.string "info_long", limit: 200, default: "多行的简介", null: false, comment: "长简介"
    t.string "current_professional", limit: 200, default: "", null: false, comment: "用户当前职业"
    t.integer "current_annual_income", default: 0, null: false, comment: "用户当前年收入"
    t.string "expect_professional", limit: 200, default: "", null: false, comment: "用户期望职业"
    t.integer "expect_annual_income", default: 0, null: false, comment: "用户期望年收入"
    t.string "head_img", limit: 500, default: "https://img.177weilai.com/default/head1.png", null: false, comment: "用户头像"
    t.string "bg_img", limit: 500, default: "https://img.177weilai.com/default/bg1.png", null: false, comment: "用户背景"
    t.string "interests", limit: 200, default: "", null: false, comment: "用户感兴趣的技术岗位、编程语言（多选，以逗号隔开存放）"
    t.string "name", limit: 30, default: "", null: false, comment: "用户真实名称"
    t.integer "age", default: 0, null: false, comment: "用户年龄"
    t.string "birthday", limit: 30, default: "", null: false, comment: "用户生日"
    t.integer "sex", default: 0, null: false, comment: "用户性别 0 未知 1 男 2 女"
    t.string "country", limit: 30, default: "", null: false, comment: "用户所在国家"
    t.string "province", limit: 30, default: "", null: false, comment: "用户所在省"
    t.bigint "province_code", default: 0, null: false, comment: "用户所在省_code"
    t.string "city", limit: 30, default: "", null: false, comment: "用户所在市"
    t.bigint "city_code", default: 0, null: false, comment: "用户所在市_code"
    t.string "area", limit: 30, default: "", null: false, comment: "用户所在区"
    t.bigint "area_code", default: 0, null: false, comment: "用户所在区_code"
    t.string "address", limit: 30, default: "", null: false, comment: "用户所在详细地址"
    t.timestamp "locked_at", comment: "登录锁定到x时间"
    t.integer "lock_state", default: 0, null: false, comment: "是否锁定 0 正常 1 锁定"
    t.integer "state", limit: 1, default: 0, null: false, comment: "当前状态 0 正常 1 禁用 2 登录锁定"
    t.integer "role", default: 0, null: false, comment: "角色 1 用户 9 管理员"
    t.integer "level", default: 0, null: false, comment: "用户等级"
    t.integer "exp", default: 0, null: false, comment: "用户经验"
    t.decimal "score", precision: 10, scale: 2, default: "0.0", null: false, comment: "用户积分"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["cares_count"], name: "index_users_on_cares_count"
    t.index ["email"], name: "index_users_on_email"
    t.index ["fans_count"], name: "index_users_on_fans_count"
    t.index ["invite_user_id"], name: "index_users_on_invite_user_id"
    t.index ["nick_name"], name: "index_users_on_nick_name"
    t.index ["not_read_count"], name: "index_users_on_not_read_count"
    t.index ["order_count"], name: "index_users_on_order_count"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
    t.index ["unionid"], name: "index_users_on_unionid", unique: true
  end

  create_table "verify_codes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "code", limit: 6, null: false, comment: "email code or phone code"
    t.string "category", limit: 10, null: false, comment: "email or phone"
    t.string "email", limit: 30, default: "", null: false
    t.string "phone", limit: 30, default: "", null: false
    t.integer "fail_count", default: 0, null: false, comment: "失败次数"
    t.timestamp "expire_at", comment: "到期时间"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["code"], name: "index_verify_codes_on_code"
    t.index ["email"], name: "index_verify_codes_on_email"
    t.index ["phone", "code"], name: "index_verify_codes_on_phone_and_code"
  end

end
