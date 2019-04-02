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
        @method == method && check_path(path)
      end

      private

      def check_path(path)
        @params = {}
        route_path = @path.split('/').reject{ |s| s.empty? }
        request_path = path.split('/').reject{ |s| s.empty? }

        return false unless route_path.size == request_path.size

        route_path.each_with_index do |path, index|
          if path[0] == ':'
            params[path[1,path.size]] = request_path[index]
          else
            return false unless path == request_path[index]
          end
        end
        true
      end
    end
  end
end
