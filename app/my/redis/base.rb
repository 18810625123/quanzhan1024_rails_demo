# encoding: UTF-8
# frozen_string_literal: true
puts 'load my::redis'

if ENV["RAILS_ENV"] == 'development'
  ENV["REDIS_HOST"] = ''
end

module My
  module Redis
    class Base
      DEFAULT_EXPIRE = 3600

      class << self
        def redis
          @@db ||= ::Redis.new(
            url: ENV["REDIS_HOST"],
            password: ENV["REDIS_PASSWORD"],
            db: ENV["REDIS_DB_INDEX"]
          )
        end

        # string
        def get k
          redis.get k
        end

        def set k, v, ex = DEFAULT_EXPIRE
          redis.set k, v, ex: ex
        end

        # 删除
        def del k
          redis.del k
        end

        # 设置过期时间
        def set_expire k, ex = DEFAULT_EXPIRE
          redis.expire k, ex
        end

        # 设置过期时间
        def get_expire k
          redis.ttl k
        end

        # 是否存在k
        def exists? k
          redis.exists k
        end

        # 查询keys
        def keys k
          redis.keys k
        end
        def all_keys k
          redis.keys k
        end

      end
    end
  end
end