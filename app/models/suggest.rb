# == Schema Information
#
# Table name: suggests
#
#  id         :bigint           not null, primary key
#  user_id    :integer          default(0), not null
#  content    :string(500)      default(""), not null
#  imgs       :string(500)      default(""), not null
#  ip         :string(100)      not null
#  ua_info_id :integer          default(0), not null
#  device_id  :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Suggest < ApplicationRecord
  belongs_to :user, optional: true
  # 多态 o_id o_type
  # belongs_to :o, polymorphic: true
  belongs_to :ua_info, optional: true
  belongs_to :ip_info, class_name: "IpInfo", foreign_key: "ip", optional: true


  def self.add user_id, content, imgs, client_ip = nil, ua_info_id = nil, device_id = nil
    create!({
              user_id: user_id,
              imgs: imgs || '',
              ip: client_ip || '',
              ua_info_id: ua_info_id || 0,
              device_id: device_id || '',
              content: content,
            })
  end
end
