module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def self.not_found
        new(:get, '/404', Controller, 'not_found')
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

    end
  end
end
