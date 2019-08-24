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
        arr_path = path.split('/')
        if arr_path.last.to_i > 0
          @method == method && @path.match(arr_path[1]) && @path.match(':id')
        else
          @method == method && path.match(@path)
        end
      end

    end
  end
end
