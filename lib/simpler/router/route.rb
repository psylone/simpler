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

      def match?(method, path, env)
        @method == method && check_path(path, env)
      end

      def check_path(path, env)
        params = {}
        route_path = @path.split('/')
        request_path = path.split('/')

        return false if route_path.size != request_path.size

        if request_path.size > 2
          route_path.each_index do |index|
            params[route_path[index].delete(':').to_sym] = request_path[index] if route_path[index].match?(/^:(\w+)$/)
          end
        end

        env['simpler.request.params'] = params
      end
    end
  end
end
