module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method     = method
        @path       = path
        @controller = controller
        @action     = action
        @params     = []
      end

      def match?(method, path)
        @method == method && check_path_and_set_params(path)
      end

      private

      def check_path_and_set_params(path)
        @params.clear
        request_path = path.split('/').reject(&:empty?)
        route_path   = @path.split('/').reject(&:empty?)

        return true if request_path == route_path

        if request_path[0] == route_path[0] && request_path.size == route_path.size
          route_path.each_with_index do |elem, index|
            @params.push(elem => request_path[index]) if elem == ':id'
          end
          true
        end
      end
    end
  end
end