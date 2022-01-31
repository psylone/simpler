module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path, env)
        @method == method && match_paths(path, env)
      end

      private

      def match_paths(request_path, env)
        request_parts = request_path.split('/')
        route_parts = @path.split('/')
        return false if request_parts.size != route_parts.size

        route_parts.each_with_index do |route_part, i|
          return false if request_parts[i] != route_part && route_part[0] != ':'

          if route_part[0] == ':'
            param = route_part[1..].to_sym
            @params[param] = request_parts[i].to_i
          end
        end

        env['simpler.params'] = params
      end

    end
  end
end
