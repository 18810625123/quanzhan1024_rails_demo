# == Schema Information
#
# Table name: user_register_infos
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  password   :string(50)       default(""), not null
#  device_id  :string(40)       default(""), not null
#  user_agent :string(1000)     default(""), not null
#  ua_info_id :integer          default(0), not null
#  ip         :string(100)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserRegisterInfo < ApplicationRecord
  belongs_to :user
  belongs_to :ua_info, optional: true
  belongs_to :ip_info, class_name: "IpInfo", foreign_key: "ip", optional: true

end
