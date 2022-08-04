# frozen_string_literal: true
module My
  module Client
    class Bd

      class << self

        def access_token
          str = My::Redis::Base.get("Bd::access_token2")
          if str.blank?
            api = "https://aip.baidubce.com/oauth/2.0/token"
            json_res = My::Client::Base.get(api, { grant_type: "client_credentials",
                                                   client_id: ENV["BD_CONTENT_CHECK_API_KEY2"], client_secret: ENV["BD_CONTENT_CHECK_SECRET_KEY2"] })
            res = JSON.parse(json_res)
            My::Redis::Base.set("Bd::access_token2", res['access_token'], 10 * 24 * 3600)
            res['access_token']
          else
            str
          end
        end

        def check_img img_src
          api = "https://aip.baidubce.com/rest/2.0/solution/v1/img_censor/v2/user_defined?access_token=#{access_token}&imgUrl=#{img_src}"
          json_res = My::Client::Base.post(api)
          res = JSON.parse(json_res)
          if res['error_code'] && res['error_code'] > 0
            Rails.logger.error "百度审核出错：#{res.to_s}"
            return true
          end
          return res['data'] if res['conclusionType'] > 1
          true
        rescue
          true
        end

        def check_text text
          api = "https://aip.baidubce.com/rest/2.0/solution/v1/text_censor/v2/user_defined?access_token=#{access_token}&text=#{text}"
          res = JSON.parse HTTP.post(api)
          if res['error_code'] && res['error_code'] > 0
            Rails.logger.error "百度审核出错：#{res.to_s}"
            return true
          end
          return res['data'] if res['conclusionType'] > 1
          true
        rescue
          true
        end

        def headers
          {
            'Content-Type': 'application/json'
          }
        end

        def build_authorization_header(method, url, json_body)
          timestamp = Time.now.to_i
          nonce_str = SecureRandom.hex
          string = build_string(method, url, timestamp, nonce_str, json_body)
          signature = sign_string(string)
          params = {
            mchid: ENV['WX_MCH_ID'],
            nonce_str: nonce_str,
            serial_no: ENV['WX_MCH_NO'],
            signature: signature,
            timestamp: timestamp
          }
          token = "WECHATPAY2-SHA256-RSA2048 #{params.map { |k, v| "#{k}=\"#{v}\"" }.join(',')}"
          puts "string: \n#{string}\n\n"
          puts "signature: \n#{signature}\n\n"
          puts "token: \n#{token}"
          {
            Authorization: token
          }
        end

        def sign_string(string)
          k = OpenSSL::PKey::RSA.new(File.read("#{Rails.root.to_s}/config/cert/apiclient_key.pem"))
          result = k.sign('SHA256', string) # 商户私钥的SHA256-RSA2048签名
          Base64.strict_encode64(result) # Base64处理
        end

        def build_string(method, url, timestamp, noncestr, body)
          if method == 'GET'
            "#{method}\n#{url}\n#{timestamp}\n#{noncestr}\n\n"
          else
            "#{method}\n#{url}\n#{timestamp}\n#{noncestr}\n#{body.to_json}\n"
          end
        end

      end
    end
  end
end