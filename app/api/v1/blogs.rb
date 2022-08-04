# frozen_string_literal: true

module V1
  class Blogs < Grape::API

    resource :blogs do

      desc 'add_article'
      params do
        optional :title, type: String, allow_blank: true
        requires :content, type: String, allow_blank: false
        requires :imgs, type: String, allow_blank: false
        optional :flags, type: String, allow_blank: false
        optional :category, type: String, values: ['md', 'text'], allow_blank: false
        optional :o_id, type: Integer, allow_blank: true
        optional :o_type, type: String, values: ['Curriculum', 'CurriculumCatalog'], allow_blank: true
      end
      post 'add_article' do
        if params[:o_id]
          current_user!
          o = eval(params[:o_type]).find_by_id params[:o_id]
          custom_error! 1, "没有找到这个#{params[:o_type]}对象:#{params[:o_id]}" if o.nil?
        end
        custom_error! 1, "你已发布了一篇相同标题的文章，文章标题不可重复" if current_user.blogs.where(title: params[:title]).count > 0
        blog = current_user!.add_blog params[:title], params[:flags], params[:content], params[:imgs], params[:category], 'article', o
        custom_success blog
      end

      desc 'add_dynamic'
      params do
        optional :imgs, type: String, allow_blank: true
        optional :category, type: String, values: ['md', 'text'], allow_blank: false
        requires :content, type: String, allow_blank: false
        optional :o_id, type: Integer, allow_blank: true
        optional :o_type, type: String, values: ['Curriculum', 'CurriculumCatalog'], allow_blank: true
      end
      post 'add_dynamic' do
        if params[:o_id]
          current_user!
          o = eval(params[:o_type]).find_by_id params[:o_id]
          custom_error! 1, "没有找到这个#{params[:o_type]}对象:#{params[:o_id]}" if o.nil?
        end
        blog = current_user!.add_blog params[:title], params[:flags], params[:content], params[:imgs], params[:category], 'dynamic', o
        custom_success blog
      end

      post 'check_img' do
        res = My::Client::Bd.check_img params[:img_src]
        if res != true
          custom_error! 1, "审核失败：#{res.map { |a| a['msg'] }.join(',')}", res
        end
        custom_success
      end

      post 'check_text' do
        res = My::Client::Bd.check_text params[:text]
        if res != true
          custom_error! 1, "审核失败：#{res.map { |a| a['msg'] }.join(',')}", res
        end
        custom_success
      end

      desc '创建blog'
      params do
        requires :id, type: Integer, allow_blank: false
        requires :content, type: String, allow_blank: false
        optional :title, type: String, allow_blank: false
        optional :imgs, type: String, allow_blank: false
        optional :category, type: String, values: ['md', 'text'], allow_blank: false
      end
      post 'update' do
        current_user!
        blog = Blog.find_by_id params[:id]
        custom_error! 1, "没有找到这篇文章" if blog.nil?
        custom_error! 2, "文章作者不是你，不可修改" if blog.user.id != current_user.id
        blog.title = params[:title] if !params[:title].blank?
        blog.category = params[:category] if !params[:category].blank?
        blog.content = params[:content] if !params[:content].blank?
        blog.imgs = params[:imgs] if !params[:imgs].blank?
        blog.save!
        custom_success blog
      end

      desc 'index'
      params do
        optional :search, type: String, allow_blank: true
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'index' do
        s = params[:search]
        blogs = Blog.joins("left join users as u on u.id = blogs.user_id")
                    .where("blogs.state = 1 #{!s.blank? ? "and (blogs.title like '%#{s}%' or blogs.content like '%#{s}%' or u.nick_name like '%#{s}%')" : ""}")
                    .order("blogs.like_count desc")
                    .includes(:user, :o)
        total = blogs.count
        blogs = blogs.page(params[:page]).per(params[:limit])
        blog_jsons = blogs.as_json(include: [:user, :o])
        if current_user # 是否关注过
          cares_kv = current_user.cares_kv
          likes_kv = current_user.likes_kv 'Blog'
          blog_jsons.each do |blog_json|
            blog_json[:is_like] = likes_kv[blog_json['id']] == 1
            blog_json['user'][:is_care] = cares_kv[blog_json['user']['id']] == 1
          end
        end
        custom_success total: total, list: blog_jsons
      end

      desc 'list'
      params do
        optional :uid, type: Integer, allow_blank: true
        optional :title, type: String, allow_blank: true
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'list' do
        blogs = Blog.where(state: 1).includes(:o).order("id desc")
        if !params[:uid].blank?
          user = User.find_by_uid params[:uid]
          custom_error! 1, "没有找到这个uid" if user.nil?
          blogs = blogs.where("user_id = '#{user.id}'")
        end
        blogs = blogs.where("title like '%#{params[:title]}%'") if !params[:title].blank?
        total = blogs.count
        blogs = blogs.page(params[:page]).per(params[:limit])
        blog_jsons = blogs.as_json(include: [:o])
        custom_success total: total, list: blog_jsons
      end

      desc 'my_list'
      params do
        optional :title, type: String, allow_blank: true
        optional :page, type: Integer, default: 1, values: 1..50, allow_blank: true
        optional :limit, type: Integer, default: 10, values: 1..50, allow_blank: true
      end
      get 'my_list' do
        blogs = current_user!.blogs.where(state: 1).includes(:o).order("id desc")
        blogs = blogs.where("title like '%#{params[:title]}%'") if !params[:title].blank?
        total = blogs.count
        blogs = blogs.page(params[:page]).per(params[:limit])
        custom_success total: total, list: blogs.as_json(include: :o)
      end

      desc 'detail'
      params do
        requires :id, type: Integer, allow_blank: false
      end
      get 'detail' do
        blog = Blog.find_by_id(params[:id])
        custom_error! 1, "未找到这个id #{params[:id]}" if blog.nil?
        custom_error! 2, "这篇文章已被作者删除 #{params[:id]}" if blog.state == 0
        json = blog.as_json(include: [
          :user,
          o: {
            include: [:curriculum]
          }
        ])
        json[:videos] = blog.videos.as_json
        if current_user
          json[:is_like] = current_user.like? blog
          json['user'][:is_care] = current_user.care? blog.user
        end
        recommendeds = Blog.where(state: 1).where("id != #{blog.id}")
                           .includes(:o)
                           .order("like_count desc, created_at desc").page(1).per(5)
        blog.update read_count: blog.read_count + 1
        custom_success detail: json, recommendeds: recommendeds.as_json(include: :o)
      end

      desc 'remove'
      params do
        requires :id, type: Integer, allow_blank: false
      end
      post 'remove' do
        current_user!
        blog = Blog.find_by_id(params[:id])
        custom_error! 2, "文章作者不是你，没有权限" if current_user.id != blog.user_id
        custom_error! 1, "未找到这个id #{params[:id]}" if blog.nil?
        blog.remove
        custom_success
      end

      desc 'open'
      params do
        requires :id, type: Integer, allow_blank: false
      end
      get 'open' do
        blog = Blog.find_by_id(params[:id])
        custom_error! 1, "未找到这个id #{params[:id]}" if blog.nil?
        blog.open
        custom_success
      end

    end

  end
end
