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
        path[/\d+\z/] = ':id' if path.match(/.\/\d+\z/)
          
        @method == method && path == @path
      end

    end
  end
end
