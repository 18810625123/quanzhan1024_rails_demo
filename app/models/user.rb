# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  uid                   :string(20)       not null
#  phone                 :string(11)
#  unionid               :string(100)
#  openid                :string(100)
#  email                 :string(50)
#  fans_count            :integer          default(0), not null
#  cares_count           :integer          default(0), not null
#  order_count           :integer          default(0), not null
#  like_count            :integer          default(0), not null
#  not_read_count        :integer          default(0), not null
#  invite_code           :string(6)
#  invite_user_id        :integer          default(0)
#  invite_share_log_id   :integer          default(0), not null
#  nick_name             :string(20)       default(""), not null
#  info                  :string(25)       default("一行的简介"), not null
#  info_long             :string(200)      default("多行的简介"), not null
#  current_professional  :string(200)      default(""), not null
#  current_annual_income :integer          default(0), not null
#  expect_professional   :string(200)      default(""), not null
#  expect_annual_income  :integer          default(0), not null
#  head_img              :string(500)      default("https://img.177weilai.com/default/head1.png"), not null
#  bg_img                :string(500)      default("https://img.177weilai.com/default/bg1.png"), not null
#  interests             :string(200)      default(""), not null
#  name                  :string(30)       default(""), not null
#  age                   :integer          default(0), not null
#  birthday              :string(30)       default(""), not null
#  sex                   :integer          default(0), not null
#  country               :string(30)       default(""), not null
#  province              :string(30)       default(""), not null
#  province_code         :bigint           default(0), not null
#  city                  :string(30)       default(""), not null
#  city_code             :bigint           default(0), not null
#  area                  :string(30)       default(""), not null
#  area_code             :bigint           default(0), not null
#  address               :string(30)       default(""), not null
#  locked_at             :datetime
#  lock_state            :integer          default(0), not null
#  state                 :integer          default(0), not null
#  role                  :integer          default(0), not null
#  level                 :integer          default(0), not null
#  exp                   :integer          default(0), not null
#  score                 :decimal(10, 2)   default(0.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class User < ApplicationRecord
  has_many :user_ip_infos
  has_many :ip_infos, through: :user_ip_infos

  has_many :user_ua_infos
  has_many :ua_infos, through: :user_ua_infos

  has_many :play_logs
  has_many :access_logs

  has_many :awards
  has_many :curriculums, -> { where("no > 0").order("no asc") }, dependent: :destroy

  # 我的邀请人
  belongs_to :inviter, class_name: "User", foreign_key: "invite_user_id", optional: true
  # 我邀请注册的用户
  has_many :invite_users, class_name: "User", foreign_key: "invite_user_id"
  # 我首次访问的邀请人日志
  belongs_to :invite_share_log, class_name: "ShareLog", foreign_key: "invite_share_log_id", optional: true

  has_one :user_register_info
  has_many :user_login_histories
  alias :login_histories :user_login_histories

  has_many :user_likes, -> { where("state = 1") }
  alias :likes :user_likes

  has_many :learn_feels, -> { where("state = 1") }
  has_many :blogs, -> { where("state = 1") }
  has_many :orders, -> {}

  has_many :user_comments, -> { where("state = 1") }
  alias :comments :user_comments

  has_many :suggests

  has_many :send_messages, -> { where("to_type = 'User'").order("id desc") },
           class_name: "Message", foreign_key: "from_id"
  has_many :get_messages, -> { where("from_type = 'User'").order("id desc") },
           class_name: "Message", foreign_key: "to_id"

  has_many :user_ua_infos, class_name: "UserUaInfo"
  has_many :ua_infos, through: :user_ua_infos

  @@default_select = (User.attribute_names - ['created_at', 'updated_at']).map { |f| "users.#{f}" }
  # default_scope { select(@@default_select)} # 会造成 .count时  使用 select COUNT(id,nick_name...) 语法错误

  def to_json
    json = as_json
    json[:is_bind_wx] = is_bind_wx?
    json[:is_bind_phone] = is_bind_phone?
    json[:permissions] = permissions
    json
  end

  def update_not_read_count
    update! not_read_count: self.get_messages.where("state = 0").count
  end

  # 发送消息
  def send_message to_user, content
    Message.add self, to_user, content
  end

  # 创建blog
  def add_blog title, flags, content, imgs, category, type, o
    blog = Blog.add self, title, flags, content, imgs, category, type, o
    score = add_blog_award! blog if blog
    blog_json = blog.as_json
    blog_json[:score] = score
    blog_json
  end

  def add_blog_award! blog
    # 赠送用户学币
    if blog.content.size > 100
      score = (rand * 3 + 7).round(2)
    elsif blog.content.size > 30
      score = (rand * 4 + 4).round(2)
    elsif blog.content.size > 10
      score = (rand * 2 + 3).round(2)
    else
      score = (rand * 2 + 1).round(2)
    end
    Award.add self, score, 'AddBlog'
    self.add_score score
    User.find_by_uid(111111).send_message self, "发布内容奖励：学币#{score}，已发放到你的余额中"
    score
  end

  # 创建curriculum
  def add_curriculum title, content, head_imgs, content_imgs, students, harvest, flags, price
    Curriculum.add self, title, content, head_imgs, content_imgs, students, harvest, flags, price
  end

  # 关注取关用户
  def care care_user, state = 1
    UserCare.add self, care_user, state
  end

  # 是否关注了该 用户
  def care? user
    user_id = user.class == User ? user.id : user
    UserCare.where("user_id = #{self.id} and o_id = #{user_id} and o_type = 'User' and state = 1").count > 0
  end

  # 创建评论
  def comment o, content, device_id, ua_info_id, ip
    UserComment.add o, self, content, device_id, ua_info_id, ip
  end

  # 创建学习心得
  def learn_feel o, content
    LearnFeel.add o, self, content
  end

  # 点赞
  def like o, state = 1
    UserLike.like o, self, state
  end

  def like? o
    likes.where("user_id = #{self.id} and o_id=#{o.id} and o_type='#{o.class.to_s}' and state = 1").count > 0
  end

  def likes_kv o_type = 'UserComment'
    kv = {}
    UserLike.select(:id, :o_id).where("user_id=#{self.id} and o_type = '#{o_type}' and state = 1")
            .each { |l| kv[l.o_id] = 1 }
    kv
  end

  def cares_kv
    kv = {}
    cares.each { |care_user| kv[care_user.id] = 1 }
    kv
  end

  def learn_feel? o
    learn_feels.where("o_id=#{o.id} and o_type='#{o.class.to_s}' and state = 1").count > 0
  end

  def comment? o
    comments.where("o_id=#{o.id} and o_type='#{o.class.to_s}' and state = 1").count > 0
  end

  def order? goods
    orders.where("goods_id=#{goods.id} and goods_type='#{goods.class.to_s}' and state = 1").count > 0
  end

  # 报名 创建订单
  def order goods, ip, device_id, ua_info_id
    raise My::Error::Base.new 800001, "已购买过该课程，可直接学习" if order?(goods)
    raise My::Error::Base.new 800002, "你不能购买自己的商品" if goods.user_id == id
    Order.add goods, self, ip, device_id, ua_info_id
  end

  # 用户收到的所有报名
  def get_orders
    Order.where("o_user_id = #{self.id} and state = 1").order("id desc")
  end

  # 用户收到的所有点赞
  def get_likes
    UserLike.where("o_user_id = #{self.id} and state = 1").order("id desc")
  end

  # 用户收到的所有评论
  def get_comments
    UserComment.where("o_user_id = #{self.id} and state = 1").order("id desc")
  end

  # 所有粉丝
  def fans
    User.joins("left join user_cares as uc on uc.user_id = users.id")
        .where("uc.o_id = #{self.id} and uc.o_type = 'User' and uc.state = 1")
        .order("uc.id desc")
  end

  # 所有关注
  def cares
    User.joins("left join user_cares as uc on uc.o_id = users.id")
        .where("uc.user_id = #{self.id} and uc.o_type = 'User' and uc.state = 1")
        .order("uc.id desc")
  end

  def self.gen_uid
    uid = My::rand_str 6
    if User.find_by_uid uid
      User.gen_uid
    else
      uid
    end
  end

  # 创建一个用户
  def self.create_user account_params, password, ua_info_id, client_ip, device_id, invite_user = nil
    password = password.blank? ? '123123' : password
    # 邀请人
    if invite_user.nil?
      share_log = ShareLog.where(device_id: device_id).order("id asc").first
      if share_log and share_log.share_user_id
        invite_user = User.find_by_id share_log.share_user_id
      end
    end
    uid = User.gen_uid
    user_obj = {
      nick_name: "用户#{uid}",
      uid: uid,
      invite_code: My::rand_str(6),
      invite_user_id: invite_user&.id || '0',
      invite_share_log_id: share_log&.id || '0',
      role: 1,
      state: 0,
      score: 0,
      level: 0,
    }

    account_params.each do |k, v|
      user_obj[k] = v
    end
    User::transaction do
      user = User.create!(user_obj)
      UserRegisterInfo.create!({
                                 user_id: user.id,
                                 # password: Base64.encode64(password),
                                 password: password,
                                 device_id: device_id || '',
                                 ua_info_id: ua_info_id || '0',
                                 ip: client_ip || '',
                               })
    end
    sys_user = User.find_by_uid('111111')
    new_user = User.find_by_uid uid
    # 用户注册成功奖励
    new_user.invite_user_register_award! sys_user
    # 赠送学币
    new_user.user_register_award! sys_user
    # 关注官方号
    new_user.care sys_user
    sys_user.care new_user
    new_user
  end

  def user_register_award! sys_user
    # 赠送用户学币
    score = 100
    Award.add self, score, 'UserRegister'
    self.add_score score
    # 自动报名报名课程
    # order Curriculum.first
    # 发送系统通知
    sys_user.send_message self, "注册奖励：学币#{score}，已发放到你的余额中"
  end

  # 发放邀请用户注册奖励
  def invite_user_register_award! sys_user
    if inviter and invite_share_log
      # 在share_log中记录用户注册之后的id
      invite_share_log.update register_user_id: self.id
      # 发放邀请用户注册奖励
      score = 20
      Award.add inviter, score, 'InviteUserRegister', self
      inviter.add_score score
      # 用户自动关注邀请人
      self.care inviter
      inviter.care self
      # 发送系统通知
      sys_user.send_message inviter, "邀请用户（#{nick_name}）注册奖励：学币#{score}学币，已发放到你的余额中"
    end
  rescue
    rails_error_log $!, $@
  end

  def add_score score_number
    update score: score_number + score
  end

  def my_blog_maxlike_comment blog
    self.comments.where("blog_id", blog.id).order('like_count desc').first
  end

  def permissions
    ['home', 'access_logs', 'blogs', 'users', 'play_logs',
     'orders', 'ip_infos', 'ua_infos', 'curriculum_catalogs',
     'curriculums', 'devices', 'share_logs', 'suggests', 'user_comments']
  end

  # 创建登录历史记录
  def add_login_history ua_info_id, ip, device_id, note
    UserLoginHistory.create!({
                               user_id: self.id,
                               ua_info_id: ua_info_id || '0',
                               ip: ip || '',
                               device_id: device_id || '',
                               note: note || ''
                             })
  rescue
    rails_error_log $!, $@
  end

  # 验证是否登录锁定
  def verify_locked!
    k = "user_login_fail_count::#{self.id}"
    user_login_fail_count = My::Redis::Number.get k
    if user_login_fail_count.to_i >= 5
      expire_remaining = My::Redis::Number.get_expire(k)
      raise My::Error::Base.new 101001, "账号登录错误次数过多，账号已锁定，将于#{(expire_remaining / 60).to_i}分钟后解锁"
    end
    false
  end

  # 验证邮箱验证码
  def verify_email_code! email_code
    verify_locked!
    VerifyCode.verify_code! :email, email_code, self.email
  end

  # 验证手机验证码
  def verify_phone_code! phone_code
    verify_locked!
    VerifyCode.verify_code! :phone, phone_code, self.phone
  end



  # 验证密码
  def verify_password! password
    k = "user_login_fail_count::#{self.id}"
    verify_locked!
    if self.user_register_info.password != password
      user_login_fail_count = My::Redis::Number.incr k
      expire_remaining = My::Redis::Number.get_expire(k)
      if expire_remaining == -1
        My::Redis::Number.set_expire k, 3600 * 1
      end
      if user_login_fail_count.to_i >= 10
        raise My::Error::Base.new 101002, "账号登录错误次数过多，账号已锁定，将于#{(expire_remaining / 60).to_i}分钟后解锁"
      end
      raise My::Error::Base.new 101003, "登录密码错误(#{user_login_fail_count})，如果忘记登录密码，可以修改密码或使用验证码登录"
    else
      My::Redis::Number.del k
    end
    true
  end

  # 发验证码
  def send_phone_code
    raise My::Error::Base.new 101008, "phone格式错误" if !My::is_phone? self.phone
    VerifyCode.send_phone_code self.phone
  end

  # 发验证码
  def send_email_code
    raise My::Error::Base.new 101009, "email格式错误" if !My::is_email? self.email
    VerifyCode.send_email_code self.email
  end

  # 生成token
  def gen_token
    exp_seconds = 30 * 24 * 3600
    tokenid = My::rand_str 8
    payload = {
      id: id,
      uid: uid,
      tokenid: tokenid,
      openid: openid,
      wx_xcx_openid: wx_xcx_openid,
      iat: Time.now.to_i,
      exp: Time.now.to_i + exp_seconds,
    }
    token = JWT.encode payload, OpenSSL::PKey::RSA.new(Base64.decode64(ENV['PRIVATE_KEY'].split('\n').join("\n"))), 'RS256'
    # My::Redis::Base.set "user_token::#{self.uid}", tokenid, exp_seconds
    token
  end

  # 解析token
  def self.parse_token jwt_token
    public_key = OpenSSL::PKey::RSA.new(Base64.decode64(ENV['PUBLIC_KEY'].split('\n').join("\n")))
    payload, algorithm = JWT.decode jwt_token, public_key, true, algorithm: 'RS256'
    payload
  rescue
    rails_error_log "token非法，解析token失败：#{$!}", []
    nil
  end

  # 生成token
  def gen_admin_token
    exp_seconds = 1 * 24 * 3600
    tokenid = My::rand_str 8
    payload = {
      id: id,
      uid: uid,
      openid: openid,
      wx_xcx_openid: wx_xcx_openid,
      tokenid: tokenid,
      iat: Time.now.to_i,
      exp: Time.now.to_i + exp_seconds,
    }
    token = JWT.encode payload, OpenSSL::PKey::RSA.new(Base64.decode64(ENV['ADMIN_PRIVATE_KEY'].split('\n').join("\n"))), 'RS256'
    # My::Redis::Base.set "admin_user_token::#{self.uid}", tokenid, exp_seconds
    token
  end

  # 解析token
  def self.parse_admin_token jwt_token
    public_key = OpenSSL::PKey::RSA.new(Base64.decode64(ENV['ADMIN_PUBLIC_KEY'].split('\n').join("\n")))
    payload, algorithm = JWT.decode jwt_token, public_key, true, algorithm: 'RS256'
    payload
  rescue
    rails_error_log "token非法，解析token失败：#{$!}", []
    nil
  end

  def self.reids_find_id_by_uid uid
    return 0 if uid.blank?
    redis_key = "User::uid::#{uid}"
    user_id = My::Redis::Base.get(redis_key)
    return user_id if !user_id.blank?
    user = self.find_by_uid uid
    if user.nil?
      My::Redis::Base.set(redis_key, user.id, 24 * 3600)
      return 0
    else
      My::Redis::Base.set(redis_key, user.id, 24 * 3600)
      return user.id
    end
  rescue
    rails_error_log $!, $@
    0
  end

  def is_bind_phone?
    !self.phone.blank?
  end

  def is_bind_wx?
    !self.unionid.blank?
  end

  def delete_all!
    AccessLog.where(user_id: id).delete_all
    PlayLog.where(user_id: id).delete_all
    Award.where(user_id: id).delete_all
    Blog.where(user_id: id).delete_all
    LearnFeel.where(user_id: id).delete_all
    Message.where(from_id: id).delete_all
    Message.where(to_id: id).delete_all
    ShareLog.where(user_id: id).delete_all
    ShareLog.where(share_user_id: id).delete_all
    ShareLog.where(register_user_id: id).delete_all
    Order.where(user_id: id).delete_all
    Order.where(o_user_id: id).delete_all
    CurriculumCatalogOrder.where(user_id: id).delete_all
    UserUaInfo.where(user_id: id).delete_all
    UserIpInfo.where(user_id: id).delete_all
    UserCare.where(user_id: id).delete_all
    UserCare.where(o_id: id).delete_all
    UserComment.where(user_id: UserComment.where(user_id: id).map(&:id)).delete_all
    UserComment.where(user_id: id).delete_all
    UserComment.where(user_id: id).delete_all
    UserComment.where(o_user_id: id).delete_all
    UserLike.where(user_id: id).delete_all
    UserLoginHistory.where(user_id: id).delete_all
    UserRegisterInfo.where(user_id: id).delete_all
    VerifyCode.where(user_id: id).delete_all
    Suggest.where(user_id: id).delete_all
    UserCare.where(user_id: id).delete_all
    UserCare.where(o_id: id).where(o_type:'User').delete_all
    delete
  end

end
