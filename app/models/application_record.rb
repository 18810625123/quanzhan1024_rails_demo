class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.rails_error_log msg, stack
    if ENV['RAILS_ENV'] == 'development'
      puts msg
      puts stack
    end
    Rails.logger.error msg
    Rails.logger.error stack.join("\n")
  end
end
