module Simpler
  class Controller
    class Headers < Hash
      def initialize(response)
        @response = response
      end

      def []=(key, value)
        @response[key] = value
        super(key, value)
      end
    end
  end
end
