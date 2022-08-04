# frozen_string_literal: true

module V1
  class VerifyCodes < Grape::API

    resource :verify_codes do

      desc '发送验证码'
      params do
        requires :account, type: String, allow_blank: false
        requires :category, type: String, values: ['email', 'phone'], allow_blank: false
        requires :type, type: String, values: ['bind_phone', 'register_or_login'], allow_blank: false
      end
      post 'send' do
        user = User.where("#{params[:category]}": params[:account]).first
        if params[:type] == 'register'
          custom_error! 3, '该用户已注册，请直接登录' if user
        elsif params[:type] == 'login'
          custom_error! 4, '该用户未注册，请先注册' if !user
        elsif params[:type] == 'bind_phone'
          custom_error! 5, "该手机已绑定了其它账号，请换一个手机号" if User.find_by_phone(params[:account])
          current_user!
        end
        if params[:category] == 'email'
          custom_error! 1, 'email格式错误' if !My::is_email? params[:account]
          VerifyCode.send_email_code params[:account]
        else
          custom_error! 2, '手机号格式错误' if !My::is_phone? params[:account]
          VerifyCode.send_phone_code params[:account]
        end
        custom_success({}, '验证码发送成功')
      end

    end
  end
end
