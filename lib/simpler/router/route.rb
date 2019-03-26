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
        return false if @method != method
        # path.match(@path)
        arr_match?(path)
      end

      private

      def arr_match?(get_path) #сначала без регулярок
        route_path = @path
        get_path_array = get_path.split('/')
        route_path_array = route_path.split('/')
        return false unless get_path_array.size == route_path_array.size
        params = {}

        route_path_array.each.with_index do |route_path_element, index|
          if route_path_element[0] == ':'
            params.merge!(route_path_element[1..-1] => get_path_array[index])
          else
            return false unless route_path_element == get_path_array[index]
          end
        end
        @params = params
      end
    end
  end
end
