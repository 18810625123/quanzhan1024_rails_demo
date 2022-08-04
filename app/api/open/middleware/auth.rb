# frozen_string_literal: true

module Open
  module Middleware
    class Auth < Grape::Middleware::Base
      def before
        Rails.logger.info "request.headers.keys: #{request.headers.keys}"
        # Rails.logger.info "request.headers: #{request.headers}"
        # Rails.logger.info "request.params: #{request.params}"
        # Rails.logger.info "request.path: #{request.path}"
      end

      def request
        @req ||= Grape::Request.new(env)
      end

    end
  end
end
