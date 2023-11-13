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
        @method == method && path.match(to_regex(@path))
      end

      def extract_params(env)
        request_path_items = env['PATH_INFO'].split('/')
        path_items = @path.split('/').map { |item| item.sub(':', '') }

        params = Hash[path_items.zip(request_path_items)].delete_if { |k, v| k == v }
        env['params'] = params
      end

      private

      def to_regex(path)
        path.split('/')
            .map { |string| string.start_with?(':') ? '\d+' : string }
            .join('/')
            .concat('$')
            .then { |regex| Regexp.new regex }
      end
    end
  end
end
