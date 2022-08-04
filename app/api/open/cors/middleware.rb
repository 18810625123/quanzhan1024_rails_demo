# frozen_string_literal: true

module Open
  module Cors
    class Middleware < Grape::Middleware::Base
      def call(env)
        response = @app.call(env)
        headers = Array === response ? response[1] : response.headers
        headers.reverse_merge!({ 'Access-Control-Allow-Origin' => '*',
                                 'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE',
                                 'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
                                 'Access-Control-Allow-Credentials' => true })
        response
      end
    end
  end
end
