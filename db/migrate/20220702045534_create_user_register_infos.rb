class CreateUserRegisterInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_register_infos do |t|
      t.integer :user_id, null: false

      t.string :device_id, null: false, limit: 40, default: '', comment: '注册时的设备id'
      t.integer :ua_info_id, null: false, default: '0', comment: ''
      t.string :ip, null: false, limit: 100, default: '', comment: '注册时的IP'

      t.timestamp :created_at, null: false, default: -> {'CURRENT_TIMESTAMP'}
      t.timestamp :updated_at, null: false, default: -> {'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'}

    end

    add_index :user_register_infos, 'user_id', unique: true
    add_index :user_register_infos, 'ip'
    add_index :user_register_infos, 'ua_info_id'
    add_index :user_register_infos, 'device_id'

  end
end
