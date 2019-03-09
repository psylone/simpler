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
        if path.match(/\/\d+\z/)
          path.gsub!(/\d+/, ':id')
          @method == method && path == @path
        else
          @method == method && path.match(@path)
        end
      end

    end
  end
end
