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

      def match?(method, path)
        primary_key = @path.split('/')[-1]
        @method == method && path.gsub(/\d/, primary_key).match(@path)
      end
    end
  end
end
