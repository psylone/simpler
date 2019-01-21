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
        @method == method && match_path(path)
      end

      def extract_params(path)
        params = {}
        requests = parse_path(path)
        routes = parse_path(@path)

        requests.zip(routes).each do |request, route|
          params[route.delete!(':').to_sym] = request if route.include?(':')
        end
        params
      end

      private

      def match_path(path)
        requests = parse_path(path)
        routes = parse_path(@path)

        return false if requests.size != routes.size

        requests.zip(routes).each do |request, route|
          if route.include?(':')
            true
          else
            return false if request != route
          end
        end
      end

      def parse_path(path)
        path.split('/').reject(&:empty?)
      end
    end
  end
end
