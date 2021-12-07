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
        @method == method && parse_string_path(path)
      end

      private

      def parse_string_path(path)
        router_path = path_parts(@path)
        request_path = path_parts(path)
        return false if request_path.size != router_path.size
        new_params(router_path, request_path)
      end

      def new_params(route, path)
        route.each_with_index do |part, index|
          if part.include?(':')
            add_params(part, path[index])
          else
            false
          end
        end
      end

      def add_params(parameter, value)
        parameter = parameter.split(':')[1].to_sym

        @params[parameter] = value.to_i
      end

      def path_parts(path)
        path.split('/').reject!(&:empty?)
      end
    end
  end
end
