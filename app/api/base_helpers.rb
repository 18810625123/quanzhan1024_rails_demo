module BaseHelpers

  def client_ip
    request.headers['X-Real-Ip'] ||
      request.env['HTTP_X_REAL_IP'] ||
      request.env['action_dispatch.remote_ip'].to_s
  end

  # priority: message > code_alias > code
  def custom_error! code, message = nil, data = {}, http_code = 200, stack = nil
    Rails.logger.error message
    stack.each { |msg| Rails.logger.error msg } if stack
    error! custom_gen_body(code, message, data), http_code
  end

  def custom_success data = {}, message = '操作成功'
    custom_gen_body 0, message, data
  end

  def custom_gen_body code, message, data = {}
    {
      code: code,
      message: message,
      data: data
    }
  end

  def user_agent
    request.headers['User-Agent'] || ''
  end

  def ua_info_id
    env['api.v1.ua_info_id'] || 0
  end

  def device_id
    request.headers['Device-Id'] || ''
  end

  def is_login?
    env['api.v1.uid']
  end

  def current_user
    return @current_user if @current_user
    uid = env['api.v1.uid']
    return if uid.blank?
    @current_user = User.find_by_uid uid
    return if !@current_user
    @current_user
  end

  def current_user!
    current_user || custom_error!(900001, "请先登录")
  end

  def check_amount amount
    arr = amount.to_s.split('.')
    return arr[0].size <= 8 && arr[1].size <= 2
  end

end
