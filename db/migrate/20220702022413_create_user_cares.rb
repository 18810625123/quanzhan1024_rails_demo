class CreateUserCares < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cares do |t|
      t.integer :user_id, null: false, comment: ''
      t.integer :o_id, null: false, comment: ''
      t.string :o_type, null: false, default: 'User', comment: ''
      t.boolean :state, null: false, limit: 2, default: '1', comment: ''

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :user_cares, ['o_id','o_type','state','created_at'], name: 'fans'
    add_index :user_cares, ['user_id','o_type','state','created_at'], name: 'cares'
    add_index :user_cares, ['user_id','o_id'], name: 'care_user?'
  end
end
