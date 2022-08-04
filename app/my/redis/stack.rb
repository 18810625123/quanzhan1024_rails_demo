# encoding: UTF-8
# frozen_string_literal: true
module My
  module Redis
    class Stack < Base

      class << self

        # push
        def push k, v
          pushr k, v
        end

        def pushr k, v
          redis.rpush k, v
        end

        def pushl k, v
          redis.lpush k, v
        end

        # 删除，通过v
        def del k, count, v
          redis.lrem k, count, v
        end

        # 通过索引设置值
        def set k, i, v
          redis.lset k, i, v
        end

        # pop
        def pop v
          popr v
        end

        def popr v
          redis.rpop v
        end

        def popl v
          redis.lpop v
        end

        # 只保留区间
        def ltrim k, i1, i2
          redis.ltrim k, i1, i2
        end


        # 堆栈查-范围(从左往右)
        def range k, index1, index2
          redis.lrange k, index1, index2
        end

        def scopes k, index1, index2
          range k, index1, index2
        end

        # 堆栈查-index
        def get k, index
          redis.lindex k, index
        end

        # 堆栈查-index
        def get_all k
          scopes(k, 0, -1)
        end

        # 堆栈查-index
        def count k
          redis.llen k
        end

      end
    end
  end
end