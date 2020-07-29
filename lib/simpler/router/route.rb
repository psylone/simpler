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
        @route_path_elements = @path.split('/').delete_if{ |i| i == "" }
        @request_path_elements = path.split('/').delete_if{ |i| i == "" }

        @method == method && (path == @path || full_audit)
      end

      private

      def full_audit
        same_length? && any_params?
      end

      def same_length?
        @route_path_elements.length == @request_path_elements.length
      end

      def any_params?
        @route_path_elements.each do |i|
          if i[0] == ':'
            form_params
            return true
          end
        end
        false
      end

      def form_params
        @route_path_elements.each_with_index do |value, index|
          @params[value] = @request_path_elements[index] if value[0] == ':'
        end
      end

    end
  end
end
