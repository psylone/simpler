module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params

      def initialize(method, route_path, controller, action)
        @method = method
        @path = route_path
        @controller = controller
        @action = action
        @route_params = {}
      end

      def match?(method, url_path)
        url_path_chunks = url_path.delete_prefix('/').split('/')
        route_path_chunks = @path.delete_prefix('/').split('/')

        if url_path_chunks.count == route_path_chunks.count
          @method == method && process_paths(url_path_chunks, route_path_chunks)
        else
          false
        end
      end

      def process_paths(url_parts, route_parts)
        indexes =
          route_parts.zip(url_parts).map.with_index do |(r, u), index|
            if r.chars.first == ':'
              index
            elsif u != r
              false
            end
          end

        if indexes.include?(false)
          false
        else
          indexes.compact.each { |i| @route_params[route_parts[i].delete_prefix(':')] = url_parts[i] }
        end
      end

    end
  end
end
