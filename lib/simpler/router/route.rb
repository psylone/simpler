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
        @method == method && path == @path
        # здесь нельзя использовать match!! т.к. автоматически принимаются все пути включающие 'test' , т.е. /3333test, /tests, /test3434343
        # В видео ошибка
      end

    end
  end
end
