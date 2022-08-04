# frozen_string_literal: true

module V1
  class Users < Grape::API

    resource :users do

      desc '用户信息（自己）'
      get 'me' do
        user = current_user!
        custom_success user.to_json
      end

      desc '用户是否注册'
      params do
        requires :phone, type: String, allow_blank: false
      end
      get 'is_exist' do
        custom_error! 1, '手机号格式不正确，请重新输入' if !My::is_phone? params[:phone]
        custom_success(is_exist: User.find_by_phone(params[:phone]).nil? ? 0 : 1)
      end

      desc '用户邀请的所有人'
      params do
      end
      get 'invite_users' do
        current_user!
        custom_success total: current_user!.invite_users.count, list: current_user!.invite_users
      end

      desc '用户信息（他人）'
      params do
        requires :uid, type: String, allow_blank: false
      end
      get 'detail' do
        user = User.find_by_uid params[:uid]
        custom_error! 1, '没有这个用户' if !user
        json = user.to_json
        json[:like_count] = user.get_likes.count
        if current_user
          json[:is_care] = current_user.care?(user) ? 1 : 0
        end
        custom_success json
      end

      desc '用户信息（他人）'
      params do
        requires :k, type: String, values: ['bg_img', 'head_img', 'nick_name', 'info', 'info_long', 'sex', 'city_codes', 'interests', 'current_professional', 'birthday'], allow_blank: false
        optional :v, type: String, allow_blank: true
      end
      post 'update' do
        custom_error! 1, '头像不能为空' if params[:k] == 'head_img' and params[:v].blank?
        custom_error! 1, '背景图不能为空' if params[:k] == 'bg_img' and params[:v].blank?
        custom_error! 1, '昵称不能为空' if params[:k] == 'nick_name' and params[:v].blank?
        custom_error! 2, '用户昵称长度不能超过15个字' if params[:k] == 'nick_name' and params[:v]&.size.to_i > 15
        custom_error! 2, '用户短简介长度不能超过25个字' if params[:k] == 'info' and params[:v]&.size.to_i > 25
        custom_error! 2, '用户长简介长度不能超过200个字' if params[:k] == 'info_long' and params[:v]&.size.to_i > 200
        if params[:k] == 'city_codes'
          arr = params[:v].split(',')
          custom_error! 1, 'city参数不对' if arr.size != 3
          current_user!.update province_code: arr[0], city_code: arr[1], area_code: arr[2],
                               province: Area.find(arr[0]).name, city: Area.find(arr[1]).name, area: Area.find(arr[2]).name
        else
          current_user!.update "#{params[:k]}": (params[:v] || '')
        end
        custom_success current_user!
      end

      desc 'bind_phone'
      params do
        requires :phone, type: String, allow_blank: false
        optional :phone_code, type: String, allow_blank: false
      end
      post 'bind_phone' do
        current_user!
        custom_error! 1, "要绑定的手机格式不正确，请重新输入" if !My::is_phone? params[:phone]
        custom_error! 2, "当前账号已绑定了手机: #{current_user.phone}" if current_user.is_bind_phone?
        custom_error! 3, "该手机号:#{params[:phone]} 已被其他账号绑定" if User.find_by_phone params[:phone]
        VerifyCode.verify_code! :phone, params[:phone_code], params[:phone]
        current_user.update phone: params[:phone]
        custom_success({}, "手机绑定成功")
      end

      desc 'bind_wx'
      params do
        requires :openid, type: String, allow_blank: false
        requires :unionid, type: String, allow_blank: false
        optional :access_token, type: String, allow_blank: true
      end
      post 'bind_wx' do
        current_user!
        custom_error! 1, "您已绑定了微信" if current_user.is_bind_wx?
        custom_error! 2, "该微信号:#{params[:unionid]} 已被其他账号绑定，您可以直接用该微信号登录" if User.find_by_unionid params[:unionid]
        wx_user_info = My::Client::Wx.get_user_info params[:access_token], params[:openid]
        custom_error! 3, "绑定微信时，获取wx_user_info错误", wx_user_info if !wx_user_info['errcode'].blank?
        current_user.update({
                              openid: wx_user_info['openid'],
                              unionid: wx_user_info['unionid'],
                              nick_name: wx_user_info['nickname'],
                              sex: wx_user_info['sex'],
                              head_img: wx_user_info['headimgurl'],
                            })
        custom_success({}, "微信绑定成功")
      end

      desc 'bind_wx_xcx_openid'
      params do
        requires :code, type: String, allow_blank: false
      end
      post 'bind_wx_xcx_openid' do
        current_user!
        return custom_success 1, "你已绑定了小程序openid" if !current_user.wx_xcx_openid.blank?
        res = My::Client::Wx.get_openid params[:code], 'WX_XCX'
        custom_error! 2, "通过code获取小程序openid失败:#{res.to_s}" if res['openid'].blank? or res['unionid'].blank?
        if current_user.unionid.blank?
          if !User.find_by_unionid res['unionid']
            current_user.update unionid: res['unionid']
          end
        end
        if !User.find_by_wx_xcx_openid res['openid']
          current_user.update wx_xcx_openid: res['openid']
        else
          custom_error! 3, "该小程序openid已被其它账号绑定"
        end
        custom_success({}, "小程序openid绑定成功")
      end

      desc '关注/取关'
      params do
        requires :uid, type: Integer, allow_blank: false
        requires :state, type: Integer, values: 0..1, allow_blank: false
      end
      post 'care' do
        current_user!
        user = User.find_by_uid params[:uid]
        custom_error! 1, '没有这个用户' if user.nil?
        current_user!.care user, params[:state]
        custom_success
      end

      desc 'likes'
      params do
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 20, values: 1..50, allow_blank: true
      end
      post 'likes' do
        likes = current_user!.likes.page(params[:page]).per(params[:limit])
        custom_success likes.as_json(include: :o)
      end

      desc 'comments'
      params do
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 20, values: 1..50, allow_blank: true
      end
      post 'comments' do
        comments = current_user!.comments.page(params[:page]).per(params[:limit])
        custom_success comments.as_json(include: :o)
      end

    end
  end
end
