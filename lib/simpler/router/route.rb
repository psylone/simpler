module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :is_dynamic

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @is_dynamic = dynamic?(@path)
      end

      def match?(method, path)
        @method == method && path?(path)
      end

      private

      def path?(path)
        return true if path.match(@path)

        dynamic_path?(path)
      end

      def dynamic_path?(path)
        requested_path = path.split('/')
        route_path = @path.split('/')

        return false unless requested_path.count == route_path.count

        comparison_result = compare_path_parts(requested_path, route_path)

        return true if comparison_result.all { |result| result == true }

        false
      end	      end


      def compare_path_parts(requested_path, route_path)
        requested_path.zip(route_path).map do |requested_path_part, route_path_part|
          requested_path_part == route_path_part || dynamic?(route_path_part)
        end
      end

      def dynamic?(str)
        str.include?(':')
      end

    end
  end
end
