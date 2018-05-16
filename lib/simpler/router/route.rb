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
        if path.split('?').first == @path
          @method == method
        else
          @method == method && path.match(@path.split('/')[1]) && @path.match(':id')
        end
      end
    end
  end
end
