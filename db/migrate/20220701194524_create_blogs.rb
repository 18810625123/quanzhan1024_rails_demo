class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title, null: false, limit: 100, default: '', comment: '标题'
      t.integer :user_id, null: false, comment: ''
      t.text :content, null: false, comment: '文字内容'
      t.string :imgs, null: false, limit: 1000, default: '', comment: '图片(多个以,分隔）'
      t.string :video_ids, null: false, limit: 50, default: '', comment: '视频(多个以,分隔）'
      t.string :flags, null: false, default: '', comment: '自定义标签(多个以,分隔）'
      t.string :category, null: false, limit: 20, default: 'text', comment: '文章类型 text md img'
      t.string :md_preview_theme, null: false, limit: 20, default: 'cyanosis', comment: ''
      t.boolean :state, null: false, limit: 2, default: '1', comment: '当前状态 1 正常 0 删除'

      t.integer :like_count, null: false, default: '0', comment: '被点赞次数'
      t.integer :share_count, null: false, default: '0', comment: '被分享次数'
      t.integer :comment_count, null: false, default: '0', comment: '被评论次数'
      t.integer :read_count, null: false, default: '0', comment: '被阅读次数'

      t.string :type, null: false, limit: 30, default: 'article', comment: '类型 文章article 动态dynamic'

      t.integer :o_id, null: false, comment: ''
      t.string :o_type, null: false, comment: 'blog的主体类型 Curriculum CurriculumCatalog'

      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
    add_index :blogs, 'title'
    add_index :blogs, 'user_id'
    add_index :blogs, 'flags'
    add_index :blogs, 'state'
    add_index :blogs, 'category'
  end
end
