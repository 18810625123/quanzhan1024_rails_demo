# frozen_string_literal: true

module V1
  module Middleware
    class Check < Grape::Middleware::Base
      def before
        # Rails.logger.error request.headers.keys
        # Rails.logger.error "device_id: #{device_id}"
#         errors = []
#         if device_id.blank? or device_id.size != 36
#           errors << "device_id 缺失或不正常"
#         end
#         if user_agent.blank?
#           errors << "user_agent 缺失或不正常"
#         end
#         if client_ip.blank?
#           errors << "ip 缺失或不正常"
#         end
#         current_user_id = User.reids_find_id_by_uid(env['api.v1.uid'])
#         if errors.size > 0
#           Suggest.add current_user_id || 0, "Middleware::Check错误，系统自动记录:#{errors.join(',')}", '', client_ip, nil, device_id
#           raise My::Error::Base.new 111001, errors.join(',')
#         end
#         ua_info_id = UaInfo.add user_agent, current_user_id, client_ip, device_id
#         env['api.v1.ua_info_id'] = ua_info_id
#         IpInfo.add client_ip, current_user_id, device_id, ua_info_id
#         Device.add device_id, ua_info_id, current_user_id, client_ip, user_agent
      end

      def user_agent
        request.headers['User-Agent']
      end

      def device_id
        request.headers['Device-Id']
      end

      def client_ip
        request.headers['X-Real-Ip'] ||
          request.env['HTTP_X_REAL_IP'] ||
          request.env['action_dispatch.remote_ip'].to_s
      end

      def request
        @req ||= Grape::Request.new(env)
      end

    end
  end
end
