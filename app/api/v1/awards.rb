# frozen_string_literal: true

module V1
  class Awards < Grape::API

    resource :awards do

      desc 'get'
      params do
        requires :o_id, type: Integer, allow_blank: false
        requires :o_type, type: String, values: ['CurriculumCatalogOrder'], allow_blank: false
      end
      post 'get' do
        current_user!
        o = eval(params[:o_type]).find_by_id params[:o_id]
        custom_error! 1, '没有找到这个对象' if o.nil?
        if params[:o_type] == 'CurriculumCatalogOrder'
          custom_error! 2, '已领取过奖励' if o.award_id > 0
          score = (rand * 2 + 1).round(2)
          award = Award.add current_user, score, 'CurriculumCatalogOrder', o
          o.update award_id: award.id
          current_user.add_score score
          sys_user = User.find_by_uid 111111
          catalog = o.curriculum_catalog
          sys_user.send_message current_user, "你在课时《#{catalog.curriculum.title}-第#{catalog.no}节-#{catalog.title}》的学习中获得学习奖励，学币#{score}已发放到您余额中，可在<我的>页面右上角点击<三>查看<我的余额>，可在<全栈课堂>中报名课程，祝您学习愉快"
        end
        custom_success award
      end

      desc 'my_list'
      params do
        optional :category, type: String, values: ['CurriculumCatalogOrder', 'Other', 'InviteUserRegister'], allow_blank: true
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'my_list' do
        awards = current_user!.awards.order("id desc")
        awards = awards.where(category: params[:category]) if !params[:category].blank?
        total = awards.count
        awards = awards.page(params[:page]).per(params[:limit]).includes(:o)
        custom_success total: total, list: awards.as_json(include: :o)
      end

    end
  end
end
