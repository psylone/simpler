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
        path = idless_path(path) if id?
        @method == method && path.match("^#{@path}$")
      end

      private

      def id?
        @path.match(':id')
      end

      def idless_path(path)
        "#{path.split(%r{/\d}).first}/:id"
      end

    end
  end
end
