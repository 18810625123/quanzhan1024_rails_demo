# frozen_string_literal: true
include TencentCloud::Common
module My
  module Client
    class Sms

      class << self

        def send_tx_sms code, phone, type = nil
          secret_id = ENV['TX_SMS_SECRET_ID']
          secret_key = ENV['TX_SMS_SECRET_KEY']
          cred = Credential.new secret_id, secret_key
          # 实例化一个http选项
          # httpProfile.scheme = "https" # 在外网互通的网络环境下支持http协议(默认是https协议),建议使用https协议
          # httpProfile.req_method = "GET" # get请求(默认为post请求)
          # httpProfile.req_timeout = 30 # 请求超时时间，单位为秒(默认60秒)
          # httpProfile.endpoint = "cvm.tencentcloudapi.com" # 指定接入地域域名(默认就近接入)
          # # 实例化一个client选项，可选的，没有特殊需求可以跳过。
          # clientProfile = ClientProfile.new()
          # clientProfile.sign_method = "TC3-HMAC-SHA256" # 指定签名算法
          # clientProfile.language = "en-US" # 指定展示英文（默认为中文）
          # clientProfile.http_profile = httpProfile
          # clientProfile.debug = true # 打印debug日志
          client = TencentCloud::Sms::V20210111::Client.new cred, "ap-guangzhou", ClientProfile.new()

          phones = [phone]
          sign_name = "北京一起去未来科技"
          # sign_name = "一起去未来科技"
          if type.to_s == 'login'
            temp_id = "1411008"
          elsif type.to_s == 'register'
            temp_id = '1411007'
          else
            temp_id = '1411022'
          end
          temp_params = ["#{code}", "30"]
          req = TencentCloud::Sms::V20210111::SendSmsRequest.new phones, ENV['TX_SMS_APP_ID'], temp_id, sign_name, temp_params
          res = client.SendSms req
          res.serialize
          Rails.logger.info res.serialize
        rescue
          Rails.logger.error $!
          Rails.logger.error $@.split("\n")
          raise My::Error::Base.new 110121, "发送腾讯短信验证码异常：#{$!}"
        end

        # 有问题了
        def send_twilio_sms code, phone
          client = Twilio::REST::Client.new('AC0907c8541c82c862d4123990732d889e', 'dcb7d54fc5c71c50e0e83253eb90ab57')
          client.messages.create(
            messaging_service_sid: 'MG9ce81dbc2f097734b3270c4b4109c8f1',
            to: '+86' + phone,
            body: "[www.metayz.club] Your verify code is #{code}."
          )
        rescue
          Rails.logger.error $!
          Rails.logger.error $@.split("\n")
          raise My::Error::Base.new 110121, "发送T短信验证码异常：#{$!}"
        end

      end
    end
  end
end