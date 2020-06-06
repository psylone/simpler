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
        @method == method && path_matches?(path)
      end

      private

      def path_matches?(path)
        router_path_parts = split_path(@path) # ['tests', ':id']
        request_path_parts = split_path(path) # ['tests', '101']

        return false if router_path_parts.size != request_path_parts.size

        router_path_parts.each_with_index do |part, index| # 'tests' - 0   ':id' - 1
          if part == ':id'
            params = {}
            params[part] = request_path_parts[1]
          elsif part != request_path_parts[index]
            return false
          end
        end
      end

      def split_path(path)
        path.split('/').reject!(&:empty?)
      end
    end
  end
end
