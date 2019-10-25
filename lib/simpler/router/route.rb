module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, request_path)
        @method == method && check_path(request_path)
      end

      private

      def check_path(request_path)
        path_arr = @path.delete_prefix('/').split('/')
        request_path_arr = request_path.delete_prefix('/').split('/')

        path_route_params = []
        path_attributes = []

        request_path_route_params = []
        request_path_values = []

        path_arr.each_index {|i| i.even? ? path_route_params << path_arr[i] : path_attributes << path_arr[i]}
        request_path_arr.each_index {|i| i.even? ? request_path_route_params << request_path_arr[i] : request_path_values << request_path_arr[i]}

        if path_arr.size == request_path_arr.size && path_route_params == request_path_route_params
          @params = {}

          request_path_values.each_with_index do |request_path_value, index|
            key = path_attributes[index].delete(':').to_sym
            value = request_path_value.to_i.zero? ? request_path_value : request_path_value.to_i

            @params[key] = value  
          end

          true
        else
          false
        end
      end
    end
  end
end
