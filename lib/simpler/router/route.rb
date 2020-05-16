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
        request_parts = path_parts(path)
        route_parts = path_parts(@path)

        res = {}
        route_parts.each_with_index do |val, index|
          res[val.delete(':').to_sym] = request_parts[index] if val.start_with?(':')
        end
        return res
      end

      def path_parts(path)
        path.split('/').reject(&:empty?)
      end

      private

      def path_match?(path)
        request_parts = path_parts(path)
        route_parts = path_parts(@path)

        return false if request_parts.size != route_parts.size
        request_parts[0] == route_parts[0]
      end
    end
  end
end
