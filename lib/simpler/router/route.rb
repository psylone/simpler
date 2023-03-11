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
        @method == method && path.match(@path)
        @method == method && path_match?(path)
      end

      def variables(path)
        path_request = split_path(path)
        path_route = split_path(@path)
        path_route.zip(path_request).each.with_object({}) do |(route, request), variables|
          variables[route[1..-1].to_sym] = request if route[0] == ':'
        end
      end

      private


      def path_match?(path)
        path_request = split_path(path)
        path_route = split_path(@path)

        return false if path_request.count != path_route.count

        path_route.zip(path_request).all? { |route, request| request == route || route[0] == ':' }
      end

      def split_path(path)
        path.split('/')[1..-1]
      end
    end
  end
end
