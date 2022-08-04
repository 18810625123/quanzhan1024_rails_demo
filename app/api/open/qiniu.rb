# frozen_string_literal: true

module Open
  class Qiniu < Grape::API

    resource :qiniu do

      desc 'callback'
      params do
      end
      get 'callback' do
        Rails.logger.info '---------------------qiniu回调（START）----------------------'
        Rails.logger.info params.keys
        Rails.logger.info params
        Rails.logger.info '---------------------qiniu回调（END）----------------------'
        return 1
      end

    end
  end
end
