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
        params_clear
      end

      def match?(method, path)
        @method == method && processing_path(path)
      end

      private

      def processing_path(path)
        params_clear
        requests = parse_path(path)
        routes = parse_path(@path)
        processing(requests, routes)
      end

      def processing(requests, routes)
        requests.zip(routes).each do |request, route|
          return false if route.nil?

          if route.include?(':')
            set_params(request, route)
          else
            return false if compare?(request, route)
          end
        end
      end

      def compare?(request, route)
        request != route
      end

      def set_params(request, route)
        params[route.delete!(':').to_sym] = request
      end

      def parse_path(path)
        path.split('/').reject!(&:empty?)
      end

      def params_clear
        @params.clear
      end
    end
  end
end
