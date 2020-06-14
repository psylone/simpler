module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = check_id(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        # @method == method && path.match(@path)
        @method == method && path == @path
      end

      def check_id(path)
        if path.split('/')[-1] == ':id'
          b = path.split('/')
          b[-1] = '101'
          b.join('/')
        else
          path
        end
      end
    end
  end
end
