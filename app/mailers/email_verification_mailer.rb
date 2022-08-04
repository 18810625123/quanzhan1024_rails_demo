class EmailVerificationMailer < ApplicationMailer

  def email_verification_code verify_code
    @code = verify_code.code
    result = mail(to: verify_code.email, subject: '[metayz.club] 编程学习网邮箱验证码')
    result
  end

end
