module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        splitted_request_path = path.split('/')
        splitted_path = @path.split('/')
        @method == method && splitted_request_path.size == splitted_path.size &&  /\/#{splitted_path[-2]}\/\d+/.match(path)
      end
    end
  end
end
