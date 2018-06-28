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
        if @path.include?(':id')
          path_id = path.split('/')[2]
          return path_match = false if path_id.nil?
          path_match = path.match @path.gsub(':id', path_id)
        else
          path_match = path.match(@path)
        end
        @method == method && path_match
      end
    end
  end
end
