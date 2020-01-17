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

      def match?(method, path)
        @method == method && path.match(path_pattern)
      end

      def add_params_to(request)
        route_params = extract_params(request.path_info)
        request.params.merge!(route_params)
      end

      private

      def extract_params(request_path)
        route_params = @path.match(/:[[:alpha:]]+\w+/)
        return {} if route_params.nil?

        param_name = route_params[0].sub(':', '')
        param_value = request_path.scan(path_pattern).flatten[0]
        { param_name => param_value }
      end

      def path_pattern
        template_str = @path.gsub(/\/(:[[:alpha:]]+\w+)/, '\\/(\\w+)')
        Regexp.new(template_str)
      end

    end
  end
end
