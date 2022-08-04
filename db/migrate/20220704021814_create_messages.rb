class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :from_id, null: false, comment: ''
      t.integer :to_id, null: false, comment: ''
      t.string :from_type, null: false, comment: 'User Group'
      t.string :to_type, null: false, comment: 'User Group'
      t.string :content, null: false, comment: ''
      t.boolean :state, null: false, default: '0', limit: 2, comment: '未读 0  已读 1'

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :messages, ['to_id', 'to_type', 'state']
    add_index :messages, ['from_id', 'from_type', 'state']

  end
end
