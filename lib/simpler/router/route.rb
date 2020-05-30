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
        @method == method && path_match?(path)
      end

      def params(path)
        route_path = split_path(@path)
        request_path = split_path(path)

        route_path.zip(request_path).each.with_object({}) do |(route, request), params|
          params[route[1..-1].to_sym] = request if route[0] == ':'
        end
      end

      private

      def path_match?(path)
        request_path = split_path(path)
        route_path = split_path(@path)

        return false if request_path.size != route_path.size

        route_path.zip(request_path).all? do |route, request|
          request == route || route[0] == ':'
        end
      end

      def split_path(path)
        path.split('/')[1..-1]
      end
    end
  end
end
