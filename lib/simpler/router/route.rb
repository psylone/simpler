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
        @route_path_elements = @path.split('/').reject!(&:empty?)
        @request_path_elements = path.split('/').reject!(&:empty?)

        @method == method && (path == @path || check_path)
      end

      private

      def check_path
        length? && params?
      end

      def length?
        @route_path_elements.length == @request_path_elements.length
      end

      def colon?(string)
        string[0] == ':'
      end

      def params?
        @route_path_elements.each do |element|
          if colon?(element)
            form_params
            return true
          end
        end
        false
      end

      def form_params
        @route_path_elements.each_with_index do |value, index|
          @params[value] = @request_path_elements[index] if colon?(value)
        end
      end
    end
  end
end
