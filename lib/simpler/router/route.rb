module Simpler
  class Router
    class Route

      require 'byebug'
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)

        route_arr = @path.split('/').reject { |el| el == '' }
        path_arr = path.split('/').reject { |el| el == '' }
        (route_arr.length == path_arr.length) && (@method == method) && (route_arr.each_with_index do |e, i|
          if e == path_arr[i]
            next
          elsif (e.match(/^:/)) #&& path_arr[i]
            @params[e] = path_arr[i]
          else
            return false
          end
        end)
      end
    end
  end
end
