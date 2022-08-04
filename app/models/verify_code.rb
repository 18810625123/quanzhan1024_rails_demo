# == Schema Information
#
# Table name: verify_codes
#
#  id         :bigint           not null, primary key
#  user_id    :integer          default(0), not null
#  code       :string(6)        not null
#  category   :string(10)       not null
#  email      :string(30)       default(""), not null
#  phone      :string(30)       default(""), not null
#  fail_count :integer          default(0), not null
#  expire_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class VerifyCode < ApplicationRecord
  # 一个手机号每40秒只能发送一次
  LIMIT_SENCONDS = 30
  # 验证码可尝试10次
  VERIFY_CODE_MAX_TRY_COUNT = 10
  # 失效时间30分钟
  VERIFY_CODE_EXPIRE_SECONDS = 30 * 60

  class << self
    # 验证邮箱验证码
    def verify_code! type, code_str, account
      if type.to_s == 'email'
        verify_code = VerifyCode.where(email: account).last
        name = '邮箱'
      elsif type.to_s == 'phone'
        verify_code = VerifyCode.where(phone: account).last
        name = '手机'
      else
        raise "verify_code?不支持的type类型：#{type}"
      end
      raise My::Error::Base.new 120101, "请先发送#{name}验证码" if !verify_code
      raise My::Error::Base.new 120102, "该#{name}验证码已过期" if verify_code.expire?
      raise My::Error::Base.new 120103, "该#{name}验证码已失效（尝试次数过多）" if verify_code.fail?
      if verify_code.code != code_str
        verify_code.fail_count += 1
        verify_code.save!
        raise My::Error::Base.new 120103, "该#{name}验证码已失效（尝试次数过多）" if verify_code.fail?
        raise My::Error::Base.new 120104, "#{name}验证码错误"
      end
      verify_code.expire_at = nil
      verify_code.save!
      true
    end

    # 创建验证码对象（但未发送）
    def create_code category, account, user_id = 0
      code = My::rand_str 6
      obj = {
        user_id: user_id,
        category: category,
        code: code,
        expire_at: Time.now + VERIFY_CODE_EXPIRE_SECONDS,
        fail_count: 0
      }
      if category.to_s == 'email'
        obj[:email] = account
      elsif category.to_s == 'phone'
        obj[:phone] = account
      else
        raise "verify_codes 不支持的category:#{category}"
      end
      VerifyCode.create!(obj)
    end

    # 发邮箱验证码
    def send_email_code email
      if VerifyCode.where(email: email).where("created_at > '#{My.now_time_str(-3600 * 0.5)}'").count >= 5
        raise My::Error::Base.new 110120, '短时间内发送次数过多，请稍后再试'
      end
      if VerifyCode.where(email: email).where("created_at > '#{My.now_time_str(-3600 * 6)}'").count >= 10
        raise My::Error::Base.new 110120, '短时间内发送次数过多，请稍后再试'
      end
      # 一分钟内只能发一条
      last = VerifyCode.where(email: email).last
      if last
        second = Time.now.to_i - last.created_at.to_i
        if second < LIMIT_SENCONDS
          raise My::Error::Base.new 110120, "请#{LIMIT_SENCONDS-second}秒后再次发送"
        end
      end

      code = VerifyCode.create_code :email, email
      EmailVerificationMailer.email_verification_code(code).deliver_now
    end

    # 发短信验证码
    def send_phone_code phone, type = nil
      if VerifyCode.where(phone: phone).where("created_at > '#{My.now_time_str(-3600 * 0.5)}'").count >= 5
        raise My::Error::Base.new 110120, '短时间内发送次数过多，请稍后再试。'
      end
      if VerifyCode.where(phone: phone).where("created_at > '#{My.now_time_str(-3600 * 6)}'").count >= 10
        raise My::Error::Base.new 110120, '短时间内发送次数过多，请稍后再试'
      end

      # 一分钟内只能发一条
      last = VerifyCode.where(phone: phone).last
      if last
        second = Time.now.to_i - last.created_at.to_i
        if second < LIMIT_SENCONDS
          raise My::Error::Base.new 110120, "请#{LIMIT_SENCONDS-second}秒后再次发送"
        end
      end
      VerifyCode::transaction do
        code = VerifyCode.create_code :phone, phone
        My::Client::Sms.send_tx_sms code.code, phone, type
        # My::Client::Sms.send_twilio_sms code.code, phone
      end
    end
  end

  def expire?
    Time.now.to_i > self.expire_at.to_i
  end

  def fail?
    self.fail_count >= VERIFY_CODE_MAX_TRY_COUNT
  end

end
