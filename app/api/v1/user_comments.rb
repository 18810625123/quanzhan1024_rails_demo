# frozen_string_literal: true

module V1
  class UserComments < Grape::API

    resource :user_comments do

      desc 'add'
      params do
        requires :o_id, type: Integer, allow_blank: false
        requires :o_type, type: String, values: ['Blog', 'UserComment', 'Curriculum', 'CurriculumCatalog'], allow_blank: false
        requires :content, type: String, allow_blank: false
      end
      post 'add' do
        current_user!
        o = eval(params[:o_type]).find_by_id params[:o_id]
        custom_error! 1, '没有找到这个对象' if o.nil?
        new_comment = current_user!.comment o, params[:content], device_id, ua_info_id, client_ip
        custom_success new_comment
      end

      desc 'remove'
      params do
        requires :id, type: Integer, allow_blank: false
      end
      post 'remove' do
        current_user!
        comment = UserComment.find_by_id params[:id]
        custom_error! 1, '没有找到这个对象' if comment.nil?
        comment.remove
        custom_success
      end

      desc 'list by o'
      params do
        requires :o_id, type: Integer, allow_blank: false
        requires :o_type, type: String, values: ['UserComment', 'LearnFeel', 'CurriculumCatalog', 'Blog', 'Curriculum'], allow_blank: false
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'list' do
        o = eval(params[:o_type]).find_by_id(params[:o_id])
        custom_error! 1, "未找到#{params[:o_type]} id #{params[:id]}" if o.nil?
        comments = o.comments.page(params[:page]).per(params[:limit]).includes(:user, { all_comments: [:user] })

        # 获取所有点赞信息
        likes_kv = current_user ? current_user.likes_kv : {}

        # 获取>=2级的所有评论放到根评论下
        jsons = comments.as_json(include: [:user, all_comments: { include: [:user] }])
        jsons.each_with_index do |comment1, i|
          comment1['is_like'] = likes_kv[comment1['id']] == 1 ? 1 : 0 if likes_kv # 是否点赞过
          comment1['all_comments'].each_with_index do |comment2, j|
            comment2['is_like'] = likes_kv[comment2['id']] == 1 ? 1 : 0 if likes_kv # 是否点赞过
            comment2[:user] = comments[i].all_comments[j].user.as_json
          end
        end
        custom_success total: o.comments.count, list: jsons
      end

    end

  end
end
