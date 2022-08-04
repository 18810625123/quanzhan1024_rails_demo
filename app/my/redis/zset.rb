# encoding: UTF-8
# frozen_string_literal: true
module My
  module Redis

    # set集合 元素不可重复 有序
    class ZSet < Base

      class << self

        # 添加
        def add k1, v, k2
          redis.zadd k1, v, k2
        end

        def sort k, i1, i2
          redis.zrange k, i1, i2
        end
        def sort_rev k, i1, i2
          redis.zrevrange k, i1, i2
        end

        # 操作删除
        def del k1, k2
          redis.zrem k1, k2
        end

        # 获取所有k总量
        def count k
          redis.scard k
        end
        def size k
          count k
        end

      end
    end
  end
end