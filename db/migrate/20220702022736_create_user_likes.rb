class CreateUserLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_likes do |t|
      t.integer :user_id, null: false, comment: '点赞的用户'
      t.integer :o_id, null: false, comment: ''
      t.string :o_type, null: false, comment: '点赞的主体类型  Blog UserComment Curriculum CurriculumCatalog'
      t.boolean :state, null: false, limit: 2, default: '1', comment: ''

      t.integer :o_user_id, null: false, comment: '被点赞的用户（统计用）'
      t.string :parent_o_info, limit: 30, default: '', null: false, comment: '父评信息 o_type:o_id'

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :user_likes, ['o_user_id', 'state'], name: 'orders'
    add_index :user_likes, ['o_id']
    add_index :user_likes, ['user_id']
    add_index :user_likes, ['parent_o_info']
  end
end
