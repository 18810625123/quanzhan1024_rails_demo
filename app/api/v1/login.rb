# frozen_string_literal: true

module V1
  class Login < Grape::API

    resource :login do

      desc '用户登录（通过邮箱）'
      params do
        requires :email, type: String, allow_blank: false
        optional :password, type: String, allow_blank: false
        optional :email_code, type: String, allow_blank: false
        exactly_one_of :password, :email_code
      end
      post 'by_email' do
        custom_error! 1, '邮箱格式不正确，请重新输入' if !My::is_email? params[:email]
        user = User.find_by_email params[:email]
        custom_error! 2, '邮箱不存在' if !user
        if params[:password]
          user.verify_password! params[:password]
        else
          custom_error! 1, '6位邮箱验证码格式不正确，请重新输入' if !My::is_email_code? params[:email_code]
          user.verify_email_code! params[:email_code]
        end
        user.add_login_history ua_info_id, client_ip, device_id, 'by_email'
        custom_success token: user.gen_token, permissions: user.permissions
      end

      desc '用户登录（通过手机）'
      params do
        requires :phone, type: String, allow_blank: false
        optional :invite_code, type: String, allow_blank: true
        optional :phone_code, type: String, allow_blank: false
        exactly_one_of :password, :phone_code
      end
      post 'by_phone' do
        custom_error! 1, '手机格式不正确，请重新输入' if !My::is_phone? params[:phone]
        user = User.find_by_phone params[:phone]
        if params[:password]
          custom_error! 2, '账号不存在，请先注册' if user.nil?
          user.verify_password! params[:password]
        else
          custom_error! 1, '6位手机验证码格式不正确，请重新输入' if !My::is_email_code? params[:phone_code]
          if user.nil?
            # 如果没有用户，看验证码是否正确， 正确则直接注册并登录成功
            VerifyCode.verify_code! :phone, params[:phone_code], params[:phone]
            if !params[:invite_code].blank?
              invite_user = User.find_by_invite_code params[:invite_code]
              Rails.logger.error "该邀请码未找到用户:#{params[:invite_code]}" if invite_user.nil?
            end
            user = User.create_user({ phone: params[:phone]}, params[:password], ua_info_id, client_ip, device_id, invite_user)
          else
            if params[:phone_code] != '888888'
              raise My::Error::Base.new 120104, "验证码错误"
            end
          end
        end
        user.add_login_history ua_info_id, client_ip, device_id, 'by_phone'
        custom_success user: user, token: user.gen_token, permissions: user.permissions
      end

      desc '用户登录（通过wx）'
      params do
        requires :openid, type: String, allow_blank: false
        requires :unionid, type: String, allow_blank: false
        optional :access_token, type: String, allow_blank: true
        optional :invite_code, type: String, allow_blank: true
      end
      post 'by_wx' do
        user = User.where(unionid: params[:unionid]).first
        # 如未找到用户，则注册
        if user.nil?
          custom_error! 1, "注册用户时，access_token是必填的" if params[:access_token].blank?
          if !params[:invite_code].blank?
            invite_user = User.find_by_invite_code params[:invite_code]
            Rails.logger.error "该邀请码未找到用户:#{params[:invite_code]}" if invite_user.nil?
          end
          wx_user_info = My::Client::Wx.get_user_info params[:access_token], params[:openid]
          custom_error! 1, "注册用户时，获取wx_user_info错误", wx_user_info  if !wx_user_info['errcode'].blank?
          user = User.create_user({
                                    openid: wx_user_info['openid'],
                                    unionid: wx_user_info['unionid'],
                                    nick_name: wx_user_info['nickname'],
                                    sex: wx_user_info['sex'],
                                    head_img: wx_user_info['headimgurl'],
                                  }, nil, ua_info_id, client_ip, device_id, invite_user)
        end
        user.add_login_history ua_info_id, client_ip, device_id, 'by_wx'
        custom_success user: user, token: user.gen_token, permissions: user.permissions
      end

    end

  end
end
