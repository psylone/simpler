module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @dynamic = false
        @method = method
        @path = parse_path(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match(@path)      
      end

      def parse_params(path)
        return {} unless @dynamic

        path.match(@path).named_captures.transform_keys(&:to_sym)
      end

      private

      def parse_path(path)
        search_regex = /:(\w+)/
        route_path = path.dup

        @dynamic = true if route_path.gsub!(search_regex, '(?<\1>\w+)')

        "^#{route_path}$"
      end

    end
  end
end
