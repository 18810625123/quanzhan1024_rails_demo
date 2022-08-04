# == Schema Information
#
# Table name: user_login_histories
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  ip         :string(100)      default(""), not null
#  user_agent :string(400)      default(""), not null
#  ua_info_id :integer          default(0), not null
#  note       :string(255)      default(""), not null
#  device_id  :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserLoginHistory < ApplicationRecord
  belongs_to :user
end
