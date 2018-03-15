module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :id

      def initialize(method, path, controller, action, with_id)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @with_id = with_id
      end

      def match?(method, path, id)
        @id = id if @with_id
        @method == method && path.match(@path) && id.nil? != @with_id
      end

    end
  end
end
