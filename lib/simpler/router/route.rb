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
        @method == method && path.match(@path)
        getting_params(path)
        if @params.empty?
          @method == method && path.match(@path)
        else
          route_path = path.gsub(/\/(\d+)\/?/, '/:id')
          @method == method && route_path == @path
        end
      end

      def getting_params(path)
        controllers = path.scan(/\/?([a-z]+?)\//).flatten
        values = path.scan(/\/(\d+)\/?/).flatten
        @params = {}
        controllers.each_with_index do |controller, index|
          param_key = :id
          @params[param_key] = values[index] if values[index]
        end
      end
    end
  end
end
