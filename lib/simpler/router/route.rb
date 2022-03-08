module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = scan_params_keys(path)
        @route_params = {}
      end

      def match?(method, path)
        @method == method && compare_paths(path)
      end

      private

      def compare_paths(path)
        income_path_array = path.split('/')
        route_path_array = @path.split('/')

        return false unless (income_path_array - route_path_array).size == @params.size

        route_path_array.each_with_index do |el, index|
          next if el.start_with?(':')
          return false unless el == income_path_array[index]
        end

        set_route_params(path)

        true
      end

      def set_route_params(path)
        income_params = path.split('/') - @path.split('/')

        @route_params = @params.zip(income_params).to_h
      end

      def scan_params_keys(path)
        path.scan(/:\w+/).map{ |param| param.slice(1..) }
      end
    end
  end
end
