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
        @method == method && check?(path)
      end

      def check?(path)
        if path == @path
          true
        else
          check(path) == @path
        end
      end

      def check(path)
        path = path.split('/')
        path2 = @path.split('/')
        path[-1] = path2[-1]
        path.join('/')
      end
    end
  end
end
