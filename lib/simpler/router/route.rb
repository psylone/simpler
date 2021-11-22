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

      def match?(method, path)
        @method == method && path.match(path)
      end

      def route_param(env)
        path = env['PATH_INFO']
        env_path = path.split('/')
        request_path = @path.split('/')

        request_path.each_with_index.with_object({}) do |(path, i), params|
          params[path.delete(':').to_sym] = env_path[i] if path
        end
      end

      private

      def path_match?(path)
        request_path = split_path
        route_path = split_path(@path)

        return false if request_path.size != route_path.size

        route_path.zip(request_path).all? do |route, request|
          request == route || route[0] = ':'
        end
      end

      def split_path(path)
        path.split('/')[1..-1]
      end
      
    end
  end
end

