# == Schema Information
#
# Table name: user_likes
#
#  id            :bigint           not null, primary key
#  user_id       :integer          not null
#  o_id          :integer          not null
#  o_type        :string(255)      not null
#  state         :integer          default(1), not null
#  o_user_id     :integer          not null
#  parent_o_info :string(30)       default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class UserLike < ApplicationRecord
  belongs_to :user
  # 多态 o_id o_type
  belongs_to :o, polymorphic: true

  def self.like o, user, state = 1
    @o_type = o.class.to_s
    raise "state仅支持0|1：#{state}" if ![0, 1].include? state
    raise "点赞主体不支持：#{@o_type}" if !['Blog', 'LearnFeel', 'UserComment', 'Curriculum', 'CurriculumCatalog'].include? @o_type
    user_id = user.class == User ? user.id : user
    user_like = UserLike.where("user_id = #{user_id} and o_id = #{o.id} and o_type = '#{@o_type}'").first
    if user_like
      user_like.update! state: state
    else
      if state == 1
        user_like = UserLike.create!({
                                       user_id: user_id,
                                       o_id: o.id,
                                       o_type: @o_type,
                                       o_user_id: o.user_id,
                                       parent_o_info: @o_type == 'UserComment' ? "#{o.o_type}:#{o.id}" : '',
                                       state: state,
                                     })
      end
    end
    # 更新点赞数
    o.update! like_count: o.likes.count
    o.user.update! like_count: o.user.get_likes.count
    user_like
  end

end
