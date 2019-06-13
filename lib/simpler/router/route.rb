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

      def match?(env)
        @env = env
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']
        @method == method && path_match?(path, @path)
      end

      def path_match?(request_path, routes_path)
        return true if request_path == routes_path

        request_path_array = split_by_slash(request_path)
        routes_path_array = split_by_slash(routes_path)

        return false if request_path_array.size != routes_path_array.size

        parts = routes_path_array.size
        (0..parts - 1).each do |index|
          return false if (request_path_array[index] != routes_path_array[index]) && (routes_path_array[index][0] != ":")
          if routes_path_array[index][0] == ":"
            param_name = routes_path_array[index][1..-1].to_sym
            param_value = request_path_array[index]
            set_param(param_name, param_value)
          end
        end
      end

      def split_by_slash(path)
        path.split("/").reject!(&:empty?) || []
      end

      private

      def set_param(name, value)
        @env['simpler.route_params'] ||= {}
        @env['simpler.route_params'][name] = value
      end

    end
  end
end
