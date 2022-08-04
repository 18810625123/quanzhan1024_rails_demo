# == Schema Information
#
# Table name: user_comments
#
#  id              :bigint           not null, primary key
#  user_id         :integer          not null
#  o_id            :integer          not null
#  o_type          :string(255)      not null
#  content         :string(500)      default(""), not null
#  like_count      :integer          default(0), not null
#  comment_count   :integer          default(0), not null
#  state           :integer          default(1), not null
#  o_user_id       :integer          not null
#  parent_o_info   :string(30)       default(""), not null
#  root_comment_id :integer          default(0), not null
#  ip              :string(80)       default(""), not null
#  ua_info_id      :integer          default(0), not null
#  device_id       :string(45)       default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserComment < ApplicationRecord
  belongs_to :user
  belongs_to :user_comment, class_name: "UserComment", foreign_key: "o_id", optional: true
  alias :comment :user_comment
  belongs_to :learn_feel, class_name: "LearnFeel", foreign_key: "o_id", optional: true
  has_many :user_comments, -> { where("o_type = 'UserComment' and state = 1").order("id desc") },
           class_name: "UserComment", foreign_key: "o_id"
  alias :comments :user_comments
  has_many :user_likes, -> { where("o_type = 'UserComment' and state = 1").order("id desc") },
           class_name: "UserLike", foreign_key: "o_id"
  alias :likes :user_likes
  has_many :all_comments, -> { where("o_type = 'UserComment' and state = 1").order("id asc") },
           class_name: "UserComment", foreign_key: "root_comment_id"
  # 多态 o_id o_type
  belongs_to :o, polymorphic: true

  belongs_to :ua_info, optional: true
  belongs_to :ip_info, class_name: "IpInfo", foreign_key: "ip", optional: true


  # 添加评论
  def self.add o, user, content, device_id, ua_info_id, ip

    res = My::Client::Bd.check_text content
    if res != true
      raise My::Error::Base.new 100801, "文字内容审核不通过，请修改，原因：#{res.map{|a| a['msg']}.join(',')}"
    end

    @o_type = o.class.to_s
    raise "添加评论的主体不支持：#{@o_type}" if !['Blog','LearnFeel', 'UserComment', 'Curriculum', 'CurriculumCatalog'].include? @o_type
    # 将所有>=2级的评论  都加上root_comment_id（一级评论） 方便将>=2级的评论都放到一级评论（root_comment_id）下

    if @o_type == 'UserComment'
      if o.o_type == 'UserComment'
        @root_comment_id = o.root_comment_id
      else
        @root_comment_id = o.id
      end
    end
    comment = UserComment.create!({
                                    content: content,
                                    user_id: user.class == User ? user.id : user,
                                    o_id: o.id,
                                    o_type: @o_type,
                                    o_user_id: o.user_id,
                                    parent_o_info: @o_type == 'UserComment' ? "#{o.o_type}:#{o.id}" : '',
                                    root_comment_id: @root_comment_id || '0',
                                    state: 1,
                                    device_id: device_id || '',
                                    ua_info_id: ua_info_id || '',
                                    ip: ip || '',
                                  })
    # 更新评论数
    if @o_type == 'Blog' or @o_type == 'Curriculum'
      o.update! comment_count: o.all_comment_count
    else
      o.update! comment_count: o.comments.count
    end
    comment
  end

  # 删除评论
  def remove
    update state: 0
    # 更新o的评论数
    if o_type == 'Blog' or o_type == 'Curriculum' or o_type == 'LearnFeel'
      o.update! comment_count: o.all_comment_count
    else
      o.update! comment_count: o.comments.count
    end
  end

end
