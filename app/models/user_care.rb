# == Schema Information
#
# Table name: user_cares
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  o_id       :integer          not null
#  o_type     :string(255)      default("User"), not null
#  state      :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserCare < ApplicationRecord
  belongs_to :user
  # 多态 o_id o_type
  belongs_to :o, polymorphic: true

  def self.add user, care_user, state = 1
    user_id = user.class == User ? user.id : user
    care_user_id = care_user.class == User ? care_user.id : care_user
    raise My::Error::Base.new 1, "不能关注自己" if user_id == care_user_id
    user_care = UserCare.where("user_id = #{user_id} and o_id = #{care_user_id}").first
    if user_care
      user_care.update state: state
    else
      user_care = UserCare.create!(user_id: user_id, o_id: care_user_id, state: 1)
    end
    # 更新粉丝数
    user.update cares_count: user.cares.count
    # 更新关注数
    care_user.update fans_count: care_user.fans.count
    user_care
  end

end
