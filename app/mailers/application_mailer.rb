class ApplicationMailer < ActionMailer::Base
  sender_name = ENV.fetch('SENDER_NAME', "MetaYzClub123")
  sender_email = ENV.fetch('SENDER_EMAIL', "chuangye201012@163.com")
  default from: %("#{sender_name}"<#{sender_email}>)

  layout 'mailer'

  def mail(options)
    super
  end
end
