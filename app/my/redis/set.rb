# encoding: UTF-8
# frozen_string_literal: true
module My
  module Redis

    # set集合 元素不可重复
    class Set < Base

      class << self

        # 操作添加
        def push k1, k2
          redis.sadd k1, k2
        end

        # 操作删除
        def del k1, k2
          redis.srem k1, k2
        end

        # 获取所有k
        def get_all k
          redis.smembers k
        end

        # 获取所有k总量
        def count k
          redis.scard k
        end
        def size k
          count k
        end

        # 判断集合中是否包含指定数据
        def exist_key? k1, k2
          redis.sismember k1, k2
        end

      end
    end
  end
end