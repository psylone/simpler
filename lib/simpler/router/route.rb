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
        @method == method && parse_path(path) == @path # здесь нельзя использовать match! т.к.  принимаются все пути включающие 'test' , т.е. /test, /testssss, /test3434343
      end

      def parse_path(path)
        path.gsub(/\d+/, ':id')
      end

      def parse_route_params(path)
        path.split('/').last if path
      end

    end
  end
end
