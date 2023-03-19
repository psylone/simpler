module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @controller = controller
        @action = action
        @path = path_regexp(path)
        @params = {}
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

      def route_params(path)
        @params = path.match(@path).named_captures.transform_keys!(&:to_sym)
      end

      private

      def path_regexp(path)
        path.gsub(/:([\w_]+)/, '(?<\1>[0-9a-z_]+)')
      end
    end
  end
end
