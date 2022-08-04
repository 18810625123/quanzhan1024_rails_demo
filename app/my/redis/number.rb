# encoding: UTF-8
# frozen_string_literal: true
module My
  module Redis
    class Number < Base

      class << self

        # 加1
        def incr k
          redis.incr k
        end
        # 减1
        def decr k
          redis.decr k
        end

        # 加指定整数
        def incr_n k, n
          redis.incrby k, n
        end
        # 加指定浮点数
        def incr_n_float k, n
          redis.incrbyfloat k, n
        end

        # 加指定整数
        def add k, n
          redis.incrby k, n
        end
        # 加指定浮点数
        def add_float k, n
          redis.incrbyfloat k, n
        end

      end
    end
  end
end