module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @route_params = {}
      end

      def match?(method, path)
        @method == method && parse_request_path(path)
      end

      private

      def parse_request_path(path)
        router_path = @path.split('/').reject!(&:empty?)
        request_path = path.split('/').reject!(&:empty?)

        return false unless router_path.size == request_path.size

        router_path.each_with_index do |element, i|
          if element[0] == ':'
            @route_params[element] = request_path[i]
          else
            return false unless element == request_path[i]
          end
        end

        true
      end

    end
  end
end
