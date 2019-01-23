module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path_params = path
        @path = processing_paths(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && match_path?(path)
      end

      def extract_params(path)
        params = {}
        requests = parse_path(path)
        routes = parse_path(@path_params)

        requests.zip(routes).each do |request, route|
          params[route.delete!(':').to_sym] = request if route.include?(':')
        end
        params
      end

      private

      def match_path?(path)
        requests = parse_path(path)
        routes = parse_path(@path)
        requests.size == routes.size && path.match?(@path)
      end

      def processing_paths(path)
        routes = parse_path(path)

        routes.map { |route| route.sub(/:\w+/, '.+') }.join('/')
      end

      def parse_path(path)
        path.split('/').reject(&:empty?)
      end
    end
  end
end
