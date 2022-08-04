# == Schema Information
#
# Table name: blogs
#
#  id               :bigint           not null, primary key
#  title            :string(100)      default(""), not null
#  user_id          :integer          not null
#  content          :text(65535)      not null
#  imgs             :string(1000)     not null
#  video_ids        :string(50)       default(""), not null
#  flags            :string(255)      default(""), not null
#  category         :string(20)       default("text"), not null
#  md_preview_theme :string(45)       default("cyanosis"), not null
#  state            :integer          default(1), not null
#  like_count       :integer          default(0), not null
#  share_count      :integer          default(0), not null
#  comment_count    :integer          default(0), not null
#  read_count       :integer          default(0), not null
#  order_count      :integer          default(0), not null
#  type             :string(45)       default("article"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Blog < ApplicationRecord
  # 关闭type功能
  self.inheritance_column = nil

  # 多态 o_id o_type
  belongs_to :o, polymorphic: true, optional: true

  belongs_to :user
  # 一级评论
  has_many :user_comments, -> { where("o_type = 'Blog' and state = 1").order("like_count desc, id desc") },
           class_name: "UserComment", foreign_key: "o_id"
  alias :comments :user_comments
  # 点赞
  has_many :user_likes, -> { where("o_type = 'Blog' and state = 1").order("id desc") },
           class_name: "UserLike", foreign_key: "o_id"
  alias :likes :user_likes

  def self.add user, title, flags, content, imgs, category, type, o
    blog = Blog.create!({
                          title: title || '',
                          user_id: user.id,
                          flags: flags || '',
                          content: content,
                          imgs: imgs || '',
                          category: category,
                          type: type,
                          o_id: o ? o.id : 0,
                          o_type: o ? o.class.to_s : '',
                        })
    if !imgs.blank?
      imgs.split(",").each do |img_src|
        Asset.add user, img_src
      end
    end
    blog
  end

  def videos
    return [] if video_ids.blank?
    Video.where("id in (#{video_ids})")
  end

  # 所有评论数(一级和二级)
  def all_comment_count
    comments.count + comments.sum(:comment_count)
  end

  # 关闭blog
  def remove
    update state: 0
  end

  # 恢复blog
  def open
    if state == 0
      update state: 1
    end
  end

end
