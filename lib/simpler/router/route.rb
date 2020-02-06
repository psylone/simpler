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

      def params(env)
        dynamic_part = find_dynamic_path_part(env['PATH_INFO'])
        env['params'] = dynamic_part
      end

      private

      def path?(path)
        return true if path == @path

        dynamic_path?(path)
      end

      def dynamic_path?(path)
        requested_path = path.split('/')
        route_path = @path.split('/')

        return false unless requested_path.count == route_path.count

        comparison_result = compare_path_parts(requested_path, route_path)

        return true if comparison_result.all? { |result| result == true }

        false
      end	      end

      def compare_path_parts(requested_path, route_path)
        requested_path.zip(route_path).map do |requested_path_part, route_path_part|
          requested_path_part == route_path_part || dynamic?(route_path_part)
        end
      end

      def find_dynamic_path_part(path)
        return unless @is_dynamic

        requested_path = path.split('/')
        route_path = @path.split('/')
        dynamic_part = {}

        route_path.each_with_index do |route_path_part, index|
          next unless dynamic?(route_path_part)

          key = route_path_part.delete(':').to_sym
          value = requested_path[index].to_i
          dynamic_part = { key => value }
        end

        dynamic_part
      end
      
      def dynamic?(str)
        str.include?(':')
      end

    end
  end
end
