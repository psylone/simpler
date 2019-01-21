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
        @method == method && !!match_path(path)
      end
      
      
      def add_params(path)
        params = {}
        requests = parse_path(path)
        routes = parse_path(@path)

        requests.zip(routes).each do |request, route|
          if route.include?(':')
            params[route.delete!(':').to_sym] = request
          end
        end
        params 
      end
      

      private

      def match_path(path)
        requests = parse_path(path)
        routes = parse_path(@path)

        requests.zip(routes).each do |request, route|
          return false if route.nil?

          if route.include?(':')
            return true
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
