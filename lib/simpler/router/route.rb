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
        router_path_parts = path_parts(@path)
        request_path_parts = path_parts(path)

        return false if request_path_parts.size != router_path_parts.size

        router_path_parts.each_with_index do |part, index|
          if parameter?(part)
            add_params(part, request_path_parts[index])
          else
            return false unless part == request_path_parts[index]
          end
        end
      end

      def parameter?(parameter)
        parameter[0] == ':'
      end

      def add_params(parameter, value)
        parameter = parameter.split(':')[1].to_sym

        @params[parameter] = value.to_i.zero? ? value : value.to_i
      end

      def path_parts(path)
        path.split('/').reject!(&:empty?)
      end
    end
  end
end
