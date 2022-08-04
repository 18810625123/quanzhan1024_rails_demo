class CreateSuggests < ActiveRecord::Migration[7.0]
  def change
    create_table :suggests do |t|
      t.integer :user_id, null: false, default: '0', comment: ''

      t.string :content, null: false, limit: 500, default: '', comment: ''
      t.string :imgs, null: false, limit: 500, default: '', comment: ''

      t.string :ip, null: false, limit: 100, comment: ''
      t.integer :ua_info_id, null: false, default: '0'

      t.string :device_id, null: false, limit: 40, comment: ''

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :suggests, ['content']
    add_index :suggests, ['user_id']

  end
end
