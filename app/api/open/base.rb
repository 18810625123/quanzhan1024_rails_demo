# frozen_string_literal: true

module Open
  class Base < Grape::API

    format :json
    # content_type   :json, 'application/json'
    # default_format :json

    use Open::Middleware::Auth

    mount Open::Qiniu
    mount Open::Ali
    mount Open::Wx
  end
end

