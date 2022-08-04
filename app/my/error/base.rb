# frozen_string_literal: true
puts 'load my::error'
module My
  module Error
    class Base < StandardError
      attr_accessor :code

      def initialize(code, msg = nil)
        super msg
        @code = code
      end
    end
  end
end