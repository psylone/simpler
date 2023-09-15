module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :has_id

      def initialize(method, path, controller, action, has_id)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @has_id = has_id
      end

      def match?(method, path, has_id)
        @method == method && @path.match?(path) && @has_id == has_id
      end
    end
  end
end
