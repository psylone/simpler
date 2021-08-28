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
        @method == method && parse_request_path(path)
      end

      private

      def parse_request_path(path)
        router_path = parts(@path)
        request_path = parts(path)

        return false if router_path.size != request_path.size

        router_path.each_with_index do |param, value|
          @params[param] = request_path[value] if param?(param)
        end
      end

      def param?(param)
        param[0] == ':'
      end

      def parts(path)
        path.split('/').reject!(&:empty?)
      end
    end
  end
end
