class CreateAwards < ActiveRecord::Migration[7.0]
  def change
    create_table :awards do |t|
      t.integer :user_id, null: false, comment: '受益用户id'
      t.decimal :score, null: false, precision: 10, scale: 2, default: '0.00', comment: '奖励学币'
      t.boolean :state, null: false, limit: 2, default: '1', comment: '奖励发放状态 1 已发放 0 未发放'

      t.string :category, null: false, default: '0', comment: '奖励类型 UserRegister UserOrder UserRead CurriculumCatalogOrder'
      t.integer :o_id, null: false, default: '0', comment: ''
      t.string :o_type, limit: 30, null: false, default: '', comment: '奖励类型 User Order CurriculumCatalogOrder'

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :awards, ['user_id']
    add_index :awards, ['score']
    add_index :awards, ['o_id', 'o_type']
    add_index :awards, ['o_type']
  end
end
