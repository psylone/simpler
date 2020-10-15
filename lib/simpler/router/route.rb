module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path.split('/')
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        path = path.split('/')
        if @method == method && path[1] == @path[1] && !path[2].nil?^@path[2].nil?
          @params[:id] = path[2]
          true
        end
      end
    end
  end
end
