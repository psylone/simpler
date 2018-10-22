module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @route_params = {}
      end

      def match?(method, path)
        @method == method && check_path(path)
      end

      private

      def check_path(path_to_check)
        params = {}
        route_parts = @path.split('/')
        path_to_check_parts = path_to_check.split('/')
        return false if route_parts.size != path_to_check_parts.size

        route_parts.each_index do |i|
          unless route_parts[i] == path_to_check_parts[i]
            match_data = route_parts[i].match(/^\:(.+)/)
            return false if match_data.nil?
            params[match_data[1].to_sym] = path_to_check_parts[i]
          end
        end

        @route_params = params
        true
      end

    end
  end
end
