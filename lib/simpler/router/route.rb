module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        # it's from def route in routes - tests/:id
        @controller = controller
        @action = action
        @params = {}

        @path_regexp = make_regexp(@path)
      end

      def match?(method, path)
        @method == method && path.match(@path_regexp)
      end

      def path_params(env)
        # it's from current route - tests/101
        path = env['PATH_INFO']
        make_hash_from_params(path)
      end

      private

      def make_regexp(path)
        # меняем все :keys и т.д. на регекспы, чтобы tests/:id распознало 101 как :id 
        # работает не только с числами  /categories/:slug/posts
        Regexp.new("#{path.gsub(/:\w+/, '((?:)\w+)')}$")
      end

      def make_hash_from_params(path)
        # route_mask = @path.split('/').reject(&:empty?)
        # request_params = path.split('/').reject(&:empty?)
        route_mask = array_from_path(@path)
        request_params = array_from_path(path)

        route_mask.zip(request_params).each do |route, request|
          @params[route.delete!(':').to_sym] = request if route.start_with?(':')
        end
      end

      def array_from_path(path)
        path.split('/').reject(&:empty?)
      end
    end
  end
end
