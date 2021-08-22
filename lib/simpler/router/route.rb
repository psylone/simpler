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

        for i in 0..route_parts.size - 1
          if route_parts[i][0] != ':'
            return false if request_parts[i] != route_parts[i]
          else
            parameter = route_parts[i][1..].to_sym
            @params[parameter] = request_parts[i].to_i
          end
        end

        env['simpler.params'] = @params

        return true
      end
    end
  end
end
