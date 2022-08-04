# frozen_string_literal: true

module V1
  class Suggests < Grape::API

    resource :suggests do

      desc 'add'
      params do
        requires :content, type: String, allow_blank: false
        requires :imgs, type: String, allow_blank: true
      end
      post 'add' do
        s = Suggest.add current_user&.id || 0, params[:content], params[:imgs], client_ip, ua_info_id, device_id
        custom_success s
      end

    end

  end
end
