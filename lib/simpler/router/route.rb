module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :template

      def initialize(method, path, controller, action, template)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @template = template
      end

      def match?(method, path)
        @method == method && @path.match(path)
      end

    end
  end
end
