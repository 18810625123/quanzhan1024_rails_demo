class CreateVerifyCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :verify_codes do |t|
      t.integer :user_id, null: false, default: 0

      t.string :code, null: false, limit:6, comment: 'email code or phone code'
      t.string :category, null: false , limit:10, comment: 'email or phone'
      t.string :email, null: false, limit:30, default: ''
      t.string :phone, null: false, limit:30, default: ''
      t.integer :fail_count, null: false, default: 0, comment: '失败次数'
      t.timestamp :expire_at, null: true, comment: '到期时间'

      t.timestamp :created_at, null: false, default: -> {'CURRENT_TIMESTAMP'}
      t.timestamp :updated_at, null: false, default: -> {'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'}
    end

    add_index :verify_codes, ['email']
    add_index :verify_codes, ['code']
    add_index :verify_codes, ['phone', 'code']
  end
end
