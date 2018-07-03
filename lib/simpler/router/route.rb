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
        route_params(path)

        path_info = @path_info.join('/')
        @method == method && path_info.match(@path)
      end

      def route_params(path)
        @path_info = []
        @params = {}
        @split_path = path.split('/')
        @i = 0
        @path.split('/').each do |item|
          if item == @split_path[@i]
            @path_info << item

          elsif item[0] == ":"
            @params[item] = @split_path[@i]
            @path_info << item
          else
            break
          end
          @i += 1
        end
      end

      def return_params
        @params unless @params.nil? || @params.empty?
      end

    end
  end
end
