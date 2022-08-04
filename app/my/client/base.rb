# frozen_string_literal: true
puts 'load my::client'
module My
  module Client
    class Base
      class << self
        def client baseurl
          Faraday.new(url: baseurl) do |conn|
            conn.request :json
            # conn.response :json
            conn.adapter Faraday.default_adapter
          end
        end

        def get path, data = {}, headers = {}
          begin
            res = client(path).get do |req|
              req.url path
              req.params = data
              headers.each_key do |k|
                req.headers[k] = headers[k]
              end
            end
          rescue
            Rails.logger.error $!
            Rails.logger.error $@.join("\n")
            raise "ERROR #{path}: \n#{$!}"
          end
          raise "ERROR #{path}(#{res.status}): \n#{res.body}" unless [200, 201].include? res.status
          res.body
        end

        def post path, data = {}, headers = {}
          begin
            res = client(path).post do |req|
              req.url path
              req.body = data
              headers.each_key do |k|
                req.headers[k] = headers[k]
              end
            end
          rescue
            Rails.logger.error $!
            Rails.logger.error $@.join("\n")
            raise "ERROR #{path}: \n#{$!}"
          end
          raise "ERROR #{path}(#{res.status}): \n#{res.body}" unless [200, 201].include? res.status
          res.body
        end
      end

    end
  end
end