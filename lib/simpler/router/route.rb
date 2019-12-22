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
        path_split = path.split('/')
        if path_split.last.to_i > 0
          @method == method && path.match(path_split[1]) && @path.match(':id')
        else
          @method == method && path.match(@path)
      end

    end
  end
end
