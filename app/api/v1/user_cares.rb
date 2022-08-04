# frozen_string_literal: true

module V1
  class UserCares < Grape::API

    resource :user_cares do

      desc '用户粉丝列表'
      params do
        requires :uid, type: Integer, allow_blank: false
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 20, values: 1..50, allow_blank: true
      end
      get 'fans' do
        user = User.find_by_uid params[:uid]
        custom_error! "没有找到这个uid" if user.nil?
        fans = user.fans.page(params[:page]).per(params[:limit])
        total = user.fans.count
        jsons = fans.as_json
        # 是否关注过
        if current_user
          cares_kv = current_user.cares_kv
          if cares_kv
            jsons.each do |json|
              json[:is_care] = cares_kv[json['id']] == 1 ? 1 : 0
            end
          end
        end
        custom_success total: total, list: jsons
      end

      desc '用户关注列表'
      params do
        requires :uid, type: Integer, allow_blank: false
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 20, values: 1..50, allow_blank: true
      end
      get 'cares' do
        user = User.find_by_uid params[:uid]
        custom_error! "没有找到这个uid" if user.nil?
        cares = user.cares.page(params[:page]).per(params[:limit])
        total = user.cares.count
        jsons = cares.as_json
        # 是否关注过
        if current_user
          cares_kv = current_user.cares_kv
          if cares_kv
            jsons.each do |json|
              json[:is_care] = cares_kv[json['id']] == 1 ? 1 : 0
            end
          end
        end
        custom_success total: total, list: jsons
      end

    end
  end
end
