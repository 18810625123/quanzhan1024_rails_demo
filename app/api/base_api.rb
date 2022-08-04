# frozen_string_literal: true
class BaseApi < Grape::API
  # cascade false

  format :json
  # content_type   :json, 'application/json'
  # default_format :json

  # before do
  #   set_i18n_locale
  # end
  # helpers APIv1::SharedMethods
  # use APIv1::CORS::Middleware
  # use APIv1::Auth::Middleware

  rescue_from(Grape::Exceptions::ValidationErrors) do |e|
    custom_error! 110500, e.message
  end
  rescue_from(My::Error::Base) do |e|
    # 12
    # debugger
    # Suggest.add current_user_id || 0, "Middleware::Check错误，系统自动记录:#{errors.join(',')}", '', client_ip, ua_info_id, device_id
    custom_error! e.code, e.message
  end

  helpers BaseHelpers
  mount V1::Base

  rescue_from(:all) do |e|
    custom_error! e.code, e.message, stack: $@
  end

  route :any, '*path' do
    custom_error! 100404, "API不存在 [#{request.request_method}] #{request.path}", http_code: 404
  end

end
