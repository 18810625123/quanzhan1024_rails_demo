class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uid, null: false, limit: 20, comment: '用户登录用UID'
      t.string :phone, null: true, limit: 11, comment: '用户登录用手机号'
      t.string :unionid, null: true, limit: 100, comment: '用户微信unionid'
      t.string :openid, null: true, limit: 100, comment: '用户微信openid'
      t.string :wx_xcx_openid, null: true, limit: 100, comment: '用户微信openid'
      t.string :email, null: true, limit: 50, comment: '用户登录用邮箱'

      t.integer :fans_count, null: false, default: 0, comment: '用户粉丝数'
      t.integer :cares_count, null: false, default: 0, comment: '用户关注数'
      t.integer :order_count, null: false, default: 0, comment: '用户order数'
      t.integer :like_count, null: false, default: 0, comment: '用户收到点赞数'
      t.integer :not_read_count, null: false, default: 0, comment: '未读消息'

      t.string :invite_code, null: true, limit: 6, comment: '我的邀请码'
      t.integer :invite_user_id, null: false, default: '0', comment: '邀请注册的用户'
      t.integer :invite_share_log_id, null: false, default: '0', comment: '邀请注册关系建立的分享访问日志id'

      t.string :nick_name, null: false, limit: 20, default: '', comment: '昵称'
      t.string :info, null: false, limit: 25, default: '一行的简介', comment: '短简介'
      t.string :info_long, null: false, limit: 200, default: '多行的简介', comment: '长简介'
      t.string :current_professional, limit: 200, null: false, default: '', comment: '用户当前职业'
      t.integer :current_annual_income, null: false, default: 0, comment: '用户当前年收入'
      t.string :expect_professional, limit: 200, null: false, default: '', comment: '用户期望职业'
      t.integer :expect_annual_income, null: false, default: 0, comment: '用户期望年收入'
      t.string :head_img, null: false, limit: 500, default: 'https://img.177weilai.com/default/head1.png', comment: '用户头像'
      t.string :bg_img, null: false, limit: 500, default: 'https://img.177weilai.com/default/bg1.png', comment: '用户背景'
      t.string :interests, limit: 200, null: false, default: '', comment: '用户感兴趣的技术岗位、编程语言（多选，以逗号隔开存放）'

      t.string :name, null: false, limit: 30, default: '', comment: '用户真实名称'
      t.integer :age, null: false, default: 0, comment: '用户年龄'
      t.string :birthday, null: false, limit: 30, default: '', comment: '用户生日'
      t.integer :sex, null: false, default: 0, comment: '用户性别 0 未知 1 男 2 女'
      t.string :country, null: false, limit: 30, default: '', comment: '用户所在国家'
      t.string :province, null: false, limit: 30, default: '', comment: '用户所在省'
      t.integer :province_code, null: false, limit: 6, default: '0', comment: '用户所在省_code'
      t.string :city, null: false, limit: 30, default: '', comment: '用户所在市'
      t.integer :city_code, null: false, limit: 6, default: '0', comment: '用户所在市_code'
      t.string :area, null: false, limit: 30, default: '', comment: '用户所在区'
      t.integer :area_code, null: false, limit: 6, default: '0', comment: '用户所在区_code'
      t.string :address, null: false, limit: 30, default: '', comment: '用户所在详细地址'

      t.timestamp :locked_at, null: true, comment: '登录锁定到x时间'
      t.integer :lock_state, null: false, default: 0, comment: '是否锁定 0 正常 1 锁定'
      t.boolean :state, null: false, default: 0, limit: 2, comment: '当前状态 0 正常 1 禁用 2 登录锁定'
      t.integer :role, null: false, default: 0, comment: '角色 1 用户 9 管理员'
      t.integer :level, null: false, default: 0, comment: '用户等级'
      t.integer :exp, null: false, default: 0, comment: '用户经验'
      t.decimal :score, null: false, precision: 10, scale: 2, default: 0, comment: '用户积分'

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :users, :uid, unique: true
    add_index :users, :phone, unique: true
    add_index :users, :unionid, unique: true
    add_index :users, :nick_name
    add_index :users, :email
    add_index :users, :fans_count
    add_index :users, :cares_count
    add_index :users, :order_count
    add_index :users, :not_read_count
    add_index :users, :invite_user_id
  end
end
