# frozen_string_literal: true

module Open
  class Ali < Grape::API

    resource :ali do

      desc 'callback'
      params do
      end
      get 'callback' do
        Rails.logger.info '---------------------支付宝回调（START）----------------------'
        Rails.logger.info params.keys
        Rails.logger.info params
        Rails.logger.info '---------------------支付宝回调（END）----------------------'
        return 1
      end

    end
  end
end
