# frozen_string_literal: true

class ProfileReviewMailer < ApplicationMailer

  # def approved(account)
  #   @profile = account.profile
  #   @app_name = ENV.fetch('APP_NAME')
  #   @subject = 'Your identity was approved'
  #   mail(to: account.email, subject: @subject)
  # end
  #
  # def rejected(account)
  #   @profile = account.profile
  #   @app_name = ENV.fetch('APP_NAME')
  #   @subject = 'Your identity was rejected'
  #   mail(to: account.email, subject: @subject)
  # end

  def partner_active_success(account)
    i18n = I18n.locale
    I18n.locale = account.i18n
    @email = account.email
    result = mail(to: account.email, subject: I18n.t('email.partner_active_success.subject'))
    I18n.locale = i18n
    result
  end

  def login_succeeded(account)
    return unless account.send_cd? 1
    result = mail(to: account.email, subject: I18n.t('email.login_succeeded.subject'))
    account.record_send_history 1
    result
  end

  def kyc_callback_succeeded_notify(account)
    return unless account.send_cd? 5
    I18n.locale = account.i18n
    result = mail(to: account.email, subject:  I18n.t('email.kyc_callback_succeeded_notify.subject'))
    account.record_send_history 5
    result
  end

  def kyc_callback_failed_notify(account)
    return unless account.send_cd? 6
    I18n.locale = account.i18n
    result = mail(to: account.email, subject:  I18n.t('email.kyc_callback_failed_notify.subject'))
    account.record_send_history 6
    result
  end

  def account_lock_notify(account)
    return unless account.send_cd? 8
    I18n.locale = account.i18n
    result = mail(to: account.email, subject:  I18n.t('email.account_lock_notify.subject'))
    account.record_send_history 8
    result
  end

end