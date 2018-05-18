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
        @method == method && validate_path!(@path, path)
      end

      private

      def validate_path!(routes_path, request_path)
        routes_path = routes_path.split('/')[1..-1]
        request_path = request_path.split('/')[1..-1]

        return false unless routes_path.size == request_path.size

        validate_path_units!(routes_path, request_path)
      end

      def validate_path_units!(routes_path, request_path)
        routes_path.each_with_index.all? do |route_unit, index|
          valid_unit?(route_unit, request_path[index])
        end
      end

      def valid_unit?(route_unit, request_unit)
        parameter!(route_unit, request_unit) || route_unit.match(request_unit)
      end

      def parameter!(name, value)
        @params[to_symbol(name)] = value if parameter?(name)
      end

      def parameter?(name)
        name[0] == ':'
      end

      def to_symbol(name)
        name[1..-1].to_sym
      end

    end
  end
end
