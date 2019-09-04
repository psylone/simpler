module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_parts = split_path(path)
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def params(path)
        route_parts = split_path(@path)
        request_parts = split_path(path)
        route_parts.each_with_index.with_object({}) do |(route_path_part, index), params|
          params[route_path_part] = request_parts[index] if param?(route_path_part)
        end
      end

      def query_params(params)
        Hash[params.split(',').map { |str| str.split('=') }]
      end

      private

      def correct_path?(path)
        route_parts = split_path(@path)
        request_parts = split_path(path)
        return false if request_parts.size != route_parts.size

        route_parts.each_with_index.all? do |route_path_part, index|
          param?(route_path_part) || route_path_part == request_parts[index]
        end
      end

      def param?(path_part)
        path_part.include?(':')
      end

      def split_path(path)
        path.split('/')
      end
    end
  end
end
