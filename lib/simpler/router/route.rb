module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @params = {}
        @method == method && match_route(path, @path)
      end

      private

      def match_route(path, route)
        path_parts = path.split('/')
        route_parts = route.split('/')
        return false unless path_parts.count == route_parts.count

        path.split('/').each_with_index do |part, index|
          route_part = route_parts[index]
          next if add_param!(route_part, part)

          return false unless part == route_part
        end
      end

      def add_param!(key, value)
        return false unless key[0] == ':'

        params[key[1..-1].to_sym] = value
      end
    end
  end
end
