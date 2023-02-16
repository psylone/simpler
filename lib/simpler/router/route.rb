module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && match_path(path)
      end

      private

      def path_to_array(any_path)
       any_path.split('/').reject!{|i| i.empty?} 
      end

      def match_path(path)
        path_request = path_to_array(path)
        path_route = path_to_array(@path)
        compare(path_request, path_route)
      end

      def compare(req_p, route_p)
        return false unless req_p.size == route_p.size
        req_p.each_index do |i|
        end
      end
    end
  end
end
