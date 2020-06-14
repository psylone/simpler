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
        elsif(@path.split('/').include?(':id'))
          check(path) == path
        else
          false
        end
      end

      def check(path)
        path1 = @path.split('/')
        path2 = path.split('/')
        path1[-1] = path2[-1]
        path1.join('/')
      end
    end
  end
end
