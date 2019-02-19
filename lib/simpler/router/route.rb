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
        @method == method && params_match(path)
      end

      private

      def params_match(path)
        router_path = @path.split('/').reject(&:empty?)
        request_path = path.split('/').reject(&:empty?)

        return if request_path.size != router_path.size

        parse_params(router_path, request_path )
      end

      def parse_params(router_path, request_path)
        router_path.each.with_index do |e, i|
          params[e] = request_path[i] if e[0] == ':'
        end
      end
    end
  end
end
