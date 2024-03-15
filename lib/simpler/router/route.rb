module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path_for_id(path)
        @controller = controller
        @action = action
      end

      def path_for_id(path) 
        path.gsub(/:id/, '\d+')
      end

      def match?(method, path)
        @method == method && path.match(@path + '\z')
      end

    end
  end
end
