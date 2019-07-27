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

      def match?(method, path)
        @method == method && match_route(path, @path)
      end

      private

      def match_route(path, route)
        path_split = path.split('/')
        route_split = route.split('/')

        return false unless path_split.count == route_split.count

        path_split.each_with_index do |path, index|
          next if path.nil?

          route_path = route_split[index]          

          if route_path.match(':\w+')
            add_param(route_path, path)
          else
            return false unless path == route_path
          end
        end
      end

      def add_param(param, value)
        param_name = param.sub(':', '')
        
        @params[param_name.to_sym] = value
      end

    end
  end
end
