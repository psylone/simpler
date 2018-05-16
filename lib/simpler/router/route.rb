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

      def match?(env)
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']

        @method == method && path_comparison(path, env)
      end

      private

      def path_comparison(path, env)
        path = path.split('?').first  if path.include?('?')

        request_path = path.split('/')
        route_path = @path.split('/')
        params= {}
        equal_element = true

        request_path.zip(route_path).each do |element_request_path, element_route_path|
          unless element_route_path
            equal_element = false
            return equal_element
          end

          if element_route_path.include?(':')
            key = element_route_path.delete(':').to_sym
            params[key] = element_request_path
          else
            equal_element = element_route_path == element_request_path if equal_element
          end

          return equal_element unless equal_element
        end

        push_params(params, env) if equal_element

        equal_element
      end

      def push_params(params, env)
        env['simpler.params'] = params
      end
    end
  end
end
