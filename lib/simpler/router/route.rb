module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @params = {}
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && compare_path(path)
      end

      private

      def compare_path(path)
        conroller_path_parts = path_parts(@path)
        request_path_parts = path_parts(path)

        return false unless conroller_path_parts.size == request_path_parts.size

        conroller_path_parts.each_with_index do |part, index|
          if is_path_param_legit?(part, request_path_parts[index])
            add_param(part, request_path_parts[index])
            true
          else
            return false unless part == request_path_parts[index]
          end
        end
      end

      def is_path_param_legit?(part, request_part)
        is_param?(part) && is_not_action?(request_part)
      end

      def is_param?(part)
        part[0] == ':'
      end

      def is_action?(action)
        action.to_i.zero?
      end

      def is_not_action?(action)
        !is_action?(action)
      end

      def path_parts(path)
        path.split('/').reject!(&:empty?)
      end

      def add_param(param, value)
        param = param.split(':')[1].to_sym

        @params[param] = value.to_i
      end

    end
  end
end
