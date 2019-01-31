module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action, params)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = params
      end

      def match?(method, path, params)
        if params.empty?
          @method == method && path.match(@path)
        else
          # show SHOW not INDEX
          # apperently Do work with 2 levels - tests/101/questions/99
          @method == method && @path.gsub(':id', params[0].to_s).match(path)
        end
      end
    end
  end
end
