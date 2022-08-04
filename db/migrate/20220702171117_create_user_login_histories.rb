class CreateUserLoginHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :user_login_histories do |t|
      t.integer :user_id, null: false
      t.string :ip, null: false, limit: 100, default: ''
      t.integer :ua_info_id, null: false, default: '0', comment: ''
      t.string :note, null: false, default: '', comment: ''
      t.string :device_id, null: false, limit: 40, comment: ''

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :user_login_histories, 'user_id'
    add_index :user_login_histories, 'device_id'
    add_index :user_login_histories, 'ip'
  end
end
