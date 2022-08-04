# frozen_string_literal: true

module V1
  class Messages < Grape::API

    resource :messages do

      desc 'send'
      params do
        requires :from_id, type: Integer, allow_blank: false
        requires :content, type: String, allow_blank: false
      end
      post 'send' do
        current_user!
        from_user = User.find_by_id params[:from_id]
        custom_error! 1, "没有找到这个对象" if from_user.nil?
        message = current_user!.send_message from_user, params[:content]
        custom_success message
      end

      desc 'index'
      params do
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'index' do
        current_user!
        # msg = Message.find_by_sql("select max(id) as id, any_value(content) as content, from_id, to_id from play_logs where to_id = '#{self.id}' group by id")
        messages = Message.select("max(id) as id, any_value(created_at) as created_at, any_value(content) as content, any_value(state) as state, any_value(from_id) as from_id, any_value(to_id) as to_id")
               .where("to_id = #{current_user!.id}").group(:from_id).order("id desc")
               .page(params[:page]).per(params[:limit]).includes(:from_user)
        not_read_counts = {}
        ActiveRecord::Base.connection.
          execute("select from_id, count(*) as c from messages where to_id = #{current_user!.id} and state = 0 group by from_id ").each do |a|
          not_read_counts[a[0]] = a[1]
        end
        jsons = messages.as_json(include: [:from_user])
        puts "not_read_counts: #{not_read_counts.size}"
        puts not_read_counts
        jsons.each do |json|
          json[:not_read_count] = not_read_counts[json['from_id']]
        end
        custom_success list: jsons
      end

      desc 'from_list'
      params do
        requires :from_id, type: Integer, allow_blank: false
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'from_list' do
        current_user!
        from_user = User.find_by_id params[:from_id]
        custom_error! 1, "没有找到这个对象" if from_user.nil?
        messages = Message.where("(to_id = #{current_user!.id} and from_id = #{params[:from_id]}) or (from_id = #{current_user!.id} and to_id = #{params[:from_id]})")
        total = messages.count
        # 消息已读
        messages.update(state: 1)
        messages = messages.order("id desc").page(params[:page]).per(params[:limit])
        jsons = messages.as_json()
        # 更新用户未读消息数
        current_user.update_not_read_count
        custom_success total: total, list: jsons, from_user: from_user
      end

      desc 'pull_news'
      params do
        requires :from_id, type: Integer, allow_blank: false
        requires :last_id, type: Integer, allow_blank: false
      end
      get 'pull_news' do
        current_user!
        from_user = User.find_by_id params[:from_id]
        custom_error! 1, "没有找到这个对象" if from_user.nil?
        messages = Message.where("(to_id = #{current_user!.id} and from_id = #{params[:from_id]}) or (from_id = #{current_user!.id} and to_id = #{params[:from_id]})")
                          .where("id > #{params[:last_id]}")
        total = messages.count
        # 消息已读
        messages.update(state: 1)
        messages = messages.order("id asc").page(params[:page]).per(params[:limit])
        jsons = messages.as_json()
        # 更新用户未读消息数
        current_user.update_not_read_count
        custom_success total: total, list: jsons
      end

      desc 'read_all'
      params do
      end
      post 'read_all' do
        current_user!.get_messages.update(state: 1)
        custom_success
      end

    end
  end
end
