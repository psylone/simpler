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
        return unless @is_dynamic

        find_dynamic_path_parts(env['PATH_INFO'])
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

        route_path.each_with_index.all? do |route_path_part, index|
          route_path_part == requested_path[index] || dynamic?(route_path_part)
        end
      end

      def find_dynamic_path_parts(path)
        return unless @is_dynamic

        requested_path = path.split('/')
        route_path = @path.split('/')

        route_path.each_with_index.with_object({}) do |(route_path_part, index), simpler_params|
          next unless dynamic?(route_path_part)

          key = route_path_part.delete(':').to_sym
          simpler_params[key] = requested_path[index]
        end
      end
      
      def dynamic?(str)
        str.include?(':')
      end

    end
  end
end
