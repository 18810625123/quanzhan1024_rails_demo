# == Schema Information
#
# Table name: user_ua_infos
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  ua_info_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserUaInfo < ApplicationRecord
  belongs_to :user
  belongs_to :ua_info

  has_many :access_logs
  has_many :play_logs

  def self.redis_find_by_user_id_and_ua_info_id user_id, ua_info_id
    return if user_id.blank? or user_id == 0 or ua_info_id.blank? or ua_info_id == 0
    redis_key = "UserUaInfo::#{user_id}_#{ua_info_id}"
    if My::Redis::Base.exists?(redis_key) == 0
      if UserUaInfo.where("user_id = #{user_id} and ua_info_id = '#{ua_info_id}'").count == 0
        UserUaInfo.create!({
                             ua_info_id: ua_info_id,
                             user_id: user_id,
                           })
        My::Redis::Base.set(redis_key, 1, 24*3600)
      else
        My::Redis::Base.set(redis_key, 1, 24*3600)
      end
    end
  end

end
