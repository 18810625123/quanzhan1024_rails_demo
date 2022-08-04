# == Schema Information
#
# Table name: awards
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  score      :decimal(10, 2)   default(0.0), not null
#  state      :integer          default(1), not null
#  category   :string(255)      default("0"), not null
#  o_id       :integer          default(0), not null
#  o_type     :string(30)       default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Award < ApplicationRecord
  belongs_to :user
  # 多态 o_id o_type
  belongs_to :o, polymorphic: true, optional: true

  # 创建用户奖励
  def self.add user, score, category, o = nil
    Award.create!({
                    user_id: user.id,
                    o_id: o ? o.id : '0',
                    o_type: o ? o.class.to_s : '',
                    category: category,
                    score: score,
                  })
  end
end
