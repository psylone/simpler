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
        path_regexp = /^#{@path}$/
        @method == method && path.match(path_regexp)
      end

    end
  end
end
