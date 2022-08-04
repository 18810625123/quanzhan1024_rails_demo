# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  from_id    :integer          not null
#  to_id      :integer          not null
#  from_type  :string(255)      not null
#  to_type    :string(255)      not null
#  content    :string(255)      not null
#  state      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Message < ApplicationRecord
  belongs_to :from_user, class_name: "User", foreign_key: "from_id"
  belongs_to :to_user, class_name: "User", foreign_key: "to_id"

  def self.add from_user, to_user, content
    message = nil
    Message::transaction do
      message = Message.create!({
                                  from_id: from_user.id,
                                  from_type: 'User',
                                  to_id: to_user.id,
                                  to_type: 'User',
                                  content: content,
                                  state: 0,
                                })
      # 更新用户未读消息数
      to_user.update_not_read_count
    end
    message
  end
end
