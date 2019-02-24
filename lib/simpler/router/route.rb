module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end
      
      def params(env)
        router_path_parts = path_parts(@path)
        path =env['PATH_INFO']
        request_path_parts = path_parts(path)
        router_path_parts.zip(request_path_parts).each.with_object({}) do |(path_part, request_part), result|
          # /tests/:id => { id: 1 }
          next unless path_part.start_with?(':')
          result[path_part.delete(':').to_sym] = request_part
        end
      end

      def match?(method, path)
        @method == method && matching?(path)
      end
      private

      def matching?(path)
        router_path_parts  = path_parts(@path)
        request_path_parts = path_parts(path)

        return false if request_path_parts.size != router_path_parts.size
        router_path_parts.zip(request_path_parts).all? do |path_part, request_part|
          path_part.start_with?(':') || path_part == request_part
        end
      end

      def path_parts(path)
        path.split('/').reject(&:empty?)
      end

    end
  end
end
