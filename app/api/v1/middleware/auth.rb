# frozen_string_literal: true

module V1
  module Middleware
    class Auth < Grape::Middleware::Base
      def before
        author_str = env['HTTP_AUTHORIZATION']
        return if author_str.blank?
        type, jwt_token = author_str.split(' ')
        raise My::Error::Base.new 900003, 'token类型错误' if type != 'Bearer'
        payload = User.parse_token jwt_token
        if payload.blank?
          raise My::Error::Base.new 900007, 'token非法' if payload.nil?
        end
        raise My::Error::Base.new 900004, 'payload为空' if payload.nil?
        uid = payload['uid']
        tokenid = payload['tokenid']
#         raise My::Error::Base.new 900005, 'payload 没有uid or tokenid' if uid.blank? || tokenid.blank?
        raise My::Error::Base.new 900006, 'token过期 exp' if Time.current.to_i > payload['exp'].to_i
        env['api.v1.uid'] = uid
      end

      def request
        @req ||= Grape::Request.new(env)
      end

    end
  end
end
