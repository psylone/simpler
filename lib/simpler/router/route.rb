module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :method, :path, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        method == method && path.match(path_to_route)
      end

      def path_to_route
        Regexp.new("^#{@path.gsub(/:id/, '\d+')}$")
      end

      def add_params(path)
        value = path.scan(/\w+\/\d+/).join('/')
        return if value.empty?

        value = value.split('/')
        params[:id] = value[-1].to_i
      end

    end
  end
end
