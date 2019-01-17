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
        @method == method && compare_path(path)
      end

      private

      def compare_path(path)
        requests = parse_path(path)
        routes = parse_path(@path)

        requests.zip(routes).each do |request, route|
          return false if route.nil?

          if route.include?(':')
            params[route.delete!(':').to_sym] = request
          else
            return false if request != route
          end
        end
      end

      def parse_path(path)
        path.split('/').reject!(&:empty?)
      end
    end
  end
end
