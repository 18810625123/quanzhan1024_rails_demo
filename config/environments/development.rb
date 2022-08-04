require "active_support/core_ext/integer/time"

if ENV.fetch('RAILS_ENV', 'development') == 'development'
  ENV['PUBLIC_KEY'] = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3\nMEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF5cURBbXdmeTZSK2hJQmN0andm\nNApySTZ2OEw3OEFxaTBEZTZWcWZZZWMrdG1vU2RLVFlrMDZHbDV4bXhWOVdP\nZFE4bitaR2podWNVbS9KbXBSalN6ClBvS3VZdzYxUWdRK0RDa1JWZzY2YkMw\nb0xVTTZEMy9pVUlUZmpwYWs0Z2puL05nLzJzM1JJTnFlZlpNaVZ6NkEKUk9p\nMm5neVFheEJDR1g1TjUyZDF3ZmViMVdJK3NtMHAweW1ydkpuUEVmb0ZwUXFI\nbmdLTDVmMklGcWtzRzRNSQprYXk2QjFMdWtJU0dHYmpCbVd4Q1haRXlTNU9t\nV1JVSy9jc3duR3g0QVc4ekxaZzNmMjMxR2g4UDh4NUIwMEdFCnJRV1J2UHEv\nZWRVcmdUeG45RkkvMjNOOHNwYkFTV2JBaUR0RkJGa1lCOWdJS2M3UG5PM1Mx\naVl6c0RHdVd3VEIKZlFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t\nCg=="
  ENV['PRIVATE_KEY'] = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NB\nUUVBeXFEQW13Znk2UitoSUJjdGp3ZjRySTZ2OEw3OEFxaTBEZTZWcWZZZWMr\ndG1vU2RLClRZazA2R2w1eG14VjlXT2RROG4rWkdqaHVjVW0vSm1wUmpTelBv\nS3VZdzYxUWdRK0RDa1JWZzY2YkMwb0xVTTYKRDMvaVVJVGZqcGFrNGdqbi9O\nZy8yczNSSU5xZWZaTWlWejZBUk9pMm5neVFheEJDR1g1TjUyZDF3ZmViMVdJ\nKwpzbTBwMHltcnZKblBFZm9GcFFxSG5nS0w1ZjJJRnFrc0c0TUlrYXk2QjFM\ndWtJU0dHYmpCbVd4Q1haRXlTNU9tCldSVUsvY3N3bkd4NEFXOHpMWmczZjIz\nMUdoOFA4eDVCMDBHRXJRV1J2UHEvZWRVcmdUeG45RkkvMjNOOHNwYkEKU1di\nQWlEdEZCRmtZQjlnSUtjN1BuTzNTMWlZenNER3VXd1RCZlFJREFRQUJBb0lC\nQUZzUUpaOUcwajg4ekwvTQpTdGhGLzljbEJTTVA0ZGdjRTFkVGl3Vm9LOFZ5\nM0p1K09hRmc4VnNsMCtsOTFKL0VsZS9hUHE3SGgvSmlEU1JtCnRuRnJ5OFpq\nR3BaQURPdlBWa2RHeVpqQVk3MnNDYXRWMUNrVkV4T1dzNVcwVkFPVmR4VGw1\nc1Noek1PVUhMaFkKd0kwdTlKeURiVmJZVktzWkVtdThuS3hMamR1T2F6dC9F\nZVNhdzNvd1RUYzBReFpPaWE4NVozWnlDM0d5NEdpTQpVTnAvdDFneEFXbjVG\nMGVQd0FMbU1adGVDc0FRdWZmUUhueFNBNlduUm9PbmRIMXRIREZ2TnpCMllX\nWmVlZThoClJkNXBQTEU1VHU5OUpENmV6QmJRMWF1cis5bTVLWGVTSDRiclpM\nT3FiS0ZSTy9yYXlRcTJnc2p4dUhsZ1JpdGgKazhzR29VMENnWUVBL0U2NEFJ\nNFFyaHhHaGFKc0VZK1Jxd3FvWkxveC9vOTNhRWovcDVJbFNZRHJocVplRC8z\nQgpLOXlIRGxXaTVRN1JLeFQ2VDI4YjRwam5NWXhnSVpVTDVzTmRFSzI3SzRm\nNkxndXNsL2lZNVpIaWltM2swRzdjClZ2R0NKa21ZcS9uVGRYa3VMZGpoTUxL\nbGlEQmlWeWpvSWIvNGZKbmxKRSs3TkMycWE0MGFrTjhDZ1lFQXpaZm8KTFY2\naVdPdm1qWEdMYlVMNllHQmgwVUgzK3FnN25maFZLenJVcVJFNGs5YzJoRG1U\nZllvZnBKakpjUkptRVU3NApWcVFFWjhCcWhLRmlZR2xNRFJ1VmYyUTZqZ0lQ\nbWl5SWpzZ3BYUjlYK2twVW9WQmtwV2NzRnNidXozdlJXa1NtCml6ZGRjOUh4\nSTE0WWFnbnlQVEpsWU9XODlId1JkWDdjMUpITWJTTUNnWUVBeWlyRlUyU0NS\neERQRFVzOUxzRU0KWnJJdWhpK1AyYnJaWWcyRUZLQ05FaDJrRzR0NU9YVUo4\nUHhPbDVUVTVwZDkwUGlKTFZjSlVBTlcxU1AyNzFHLwpiSlBFSVpZanNOalBC\nVkJEWnE1Q3pVaWM3bkRwOUgyd1BsWmNCQlBhcW9xTy9zVXYxSHJBemtXSFQ5\nMzlIbnZmCnJSTm1wMmlrNi9pYk4wOFVEQVBQY3A4Q2dZQVhpeXJTYjBEbUwv\nV1NBd3UxY25NYnNFM2pXY3VkRDhEc0FURTMKcHlBTlVHU0xRWjBEblZoUGl3\nNittYVNQNTB4NjlQRXBjdFR5VUsyaURKMG9iMFovUmNaajlVVmpWOGNUbjcv\ndgpvZXBpdUtFcGozT0xtWm84K3Npb3Z4VS8rMnpwQ20yTUNjWVE2bHpUOFFX\nWXR4VGZmekx1MnNBOXV5dUFxZ3Q5CjZFaGh3d0tCZ0hZbEptYW1rTk5LdkZI\nWUgyOGhSRG5Wd0hkZUs5alR6bnJtT2Z0YVRZSGp6TjJYZWpJcGtmL0cKenZj\nZ2xCRXBaOXBTTnlPVDZkMWovbk1ZVDU3cS9sdTB2YS9rbnA0UnF3cmJpZGZV\nUFY1Tm1iODNTemJmZ3I1SAp0OS9TVnpRRU5ZN2VGTm10cW80NUlDK2FWWk5E\ncDdOb25HMXM4OEpURjFqeXI2cG9RVGdnCi0tLS0tRU5EIFJTQSBQUklWQVRF\nIEtFWS0tLS0tCg=="
  ENV['ADMIN_PRIVATE_KEY'] = ''
  ENV['ADMIN_PUBLIC_KEY'] = ''
  ENV['DATABASE_HOST'] = '127.0.0.1'
  ENV['DATABASE_PORT'] = '3307'
  ENV['DATABASE_USER'] = 'root'
  ENV['DATABASE_PASSWORD'] = '123'
  ENV['REDIS_HOST'] = 'redis://redis:6379'
  ENV['RABBITMQ_HOST'] = ''
  ENV['SENDER_EMAIL'] = ''
  ENV['SENDER_NAME'] = ''
  ENV['SMTP_ADDRESS'] = 'smtp.163.com'
  ENV['SMTP_PORT'] = '25'
  ENV['SMTP_DOMAIN'] = ''
  ENV['SMTP_USER_NAME'] = ''
  ENV['SMTP_USER_PASSWORD'] = ''
  ENV['TX_SMS_APP_ID'] = ''
  ENV['TX_SMS_SECRET_KEY'] = ''
  ENV['TX_SMS_SECRET_KEY'] = ''
  ActiveRecord::Base.logger=Logger.new(STDOUT)
  puts 'init dev env'
end


Rails.application.configure do

  config.hosts << 'localhost'

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.awction_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true


  # 邮件
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_ADDRESS'],
    port:                 ENV['SMTP_PORT'],
    domain:               ENV['SMTP_DOMAIN'],
    user_name:            ENV['SMTP_USER_NAME'],
    password:             ENV['SMTP_USER_PASSWORD'],
    authentication:       :plain,
    enable_starttls_auto: true
  }

end
