module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :id

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @id = nil
      end

      def match?(method, path)
        if path.split('/').last.to_i.positive?
          tmp = path.split('/')
          @id = tmp.pop
          path = tmp.push(':id').join('/')
        end

        @method == method && @path.match(path)
      end

    end
  end
end
