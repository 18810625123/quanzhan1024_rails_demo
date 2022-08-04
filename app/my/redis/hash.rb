# encoding: UTF-8
# frozen_string_literal: true
module My
  module Redis
    class Hash < Base

      class << self

        # hash
        def set k1, k2, v
          redis.hset k1, k2, v
        end

        def get k1, k2
          redis.hget k1, k2
        end

        def get_all k
          redis.hgetall k
        end

        def keys k
          redis.hkeys k
        end

      end
    end
  end
end