module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = nil
      end

      def match?(method, path)
        @method == method && path == @path # здесь нельзя использовать match! т.к.  принимаются все пути включающие 'test' , т.е. /test, /testssss, /test3434343


      end

    end
  end
end
