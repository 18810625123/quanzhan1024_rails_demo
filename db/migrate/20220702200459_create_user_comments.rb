class CreateUserComments < ActiveRecord::Migration[7.0]
  def change
    create_table :user_comments do |t|
      t.integer :user_id, null: false, comment: ''
      t.integer :o_id, null: false, comment: ''
      t.string :o_type, null: false, comment: '评论的主体类型  Blog UserComment Curriculum CurriculumCatalog'
      t.string :content, null: false, default: '', limit: 500, comment: ''
      t.integer :like_count, null: false, default: '0', comment: ''
      t.integer :comment_count, null: false, default: '0', comment: ''
      t.boolean :state, null: false, limit: 2, default: '1', comment: ''

      t.integer :o_user_id, null: false, comment: '被评论的用户（统计用）'

      t.string :parent_o_info, limit: 30, default: '', null: false, comment: '父评信息 o_type:o_id'
      t.integer :root_comment_id, default: '0', null: false, comment: '根评id'

      t.string :ip, null: false, limit: 60, comment: ''
      t.integer :ua_info_id, null: false, default: '0'
      t.string :device_id, null: false, limit: 40, comment: ''

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :user_comments, ['o_id', 'o_type', 'state'], name: 'comments'
    add_index :user_comments, ['ip']
    add_index :user_comments, ['ua_info_id']
    add_index :user_comments, ['o_user_id']
    add_index :user_comments, ['user_id']
    add_index :user_comments, ['parent_o_info']

  end
end
