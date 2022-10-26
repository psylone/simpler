module Simpler
  class Controller
    class HeadersSetter
      def initialize(response)
        @response = response
      end

      def []=(key, value)
        @response[key] = value
      end
    end
  end
end
