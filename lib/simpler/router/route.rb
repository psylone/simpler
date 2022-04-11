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
        @method == method && correct_path?(path)
      end

      def params(env)
        request = Rack::Request.new(env)
        request.params.merge(make_params(env['PATH_INFO']))
      end

      private

      def make_params(env_info)
        path = extract_params(@path)
        requests = extract_params(env_info)
        result = {}

        path.zip(requests) do |key, value|
          key = key.delete(':').to_sym
          result[key] = value
        end

        result
      end

      def extract_params(string)
        string = string.split('/')
        string.delete_at(0)
        string
      end

      def correct_path?(path)
        correct_params_count?(path) && path.match?(path_regexp)
      end

      def correct_params_count?(path)
        path.split('/').size == @path.split('/').size
      end

      def param?(param)
        param.start_with?(':')
      end

      def path_regexp
        route = extract_params(@path)
        route.map { |param| param?(param) ? '[[:alnum:]]' : param }
             .join('/')
      end
    end
  end
end