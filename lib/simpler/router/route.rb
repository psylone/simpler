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
        @method == method && path_match?(path)
      end

      private

      def path_match?(path)
        path_request = path.split('/')
        path_router = @path.split('/')
        compare(path_request, path_router)
      end

      def compare(path_request, path_router)
        return false if path_request.size != path_router.size

        path_router.each_with_index do |item, index|
          if item =~ /^:[\d\w]+$/
            save_params(item, path_request[index])
            next
          end
          return false if item != path_request[index]
        end
      end

      def save_params(key, value)
        @params[key] = value
      end
    end
  end
end
