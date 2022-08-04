# frozen_string_literal: true

module V1
  class UserLikes < Grape::API

    resource :user_likes do

      desc 'like'
      params do
        requires :o_id, type: Integer, allow_blank: false
        requires :o_type, type: String, values: ['Blog', 'UserComment','LearnFeel', 'Curriculum', 'CurriculumCatalog'], allow_blank: false
        requires :state, type: Integer, values: 0..1, allow_blank: false
      end
      post 'like' do
        current_user!
        o = eval(params[:o_type]).find_by_id params[:o_id]
        custom_error! 1, '没有找到这个对象' if o.nil?
        current_user!.like o, params[:state]
        custom_success
      end

      desc 'list'
      params do
        requires :o_id, type: Integer, allow_blank: false
        requires :o_type, type: String, values: ['User', 'UserComment','LearnFeel', 'CurriculumCatalog', 'Blog', 'Curriculum'], allow_blank: false
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'list' do
        o = eval(params[:o_type]).find_by_id(params[:o_id])
        custom_error! 1, "未找到#{params[:o_type]} id #{params[:id]}" if o.nil?
        likes = o.likes.page(params[:page]).per(params[:limit]).includes(:user)
        jsons = likes.as_json(include: [:user])
        custom_success total: o.likes.count, list: jsons
      end

    end
  end
end
