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

      def match?(method, path_params)
        @method == method && parse_path(@path, path_params)
      end

      private

      # погалаю не стоит сейчас тут создавать универсальный алгоритм парсинга под всевозможные варианты.
      # тема текущего задания инные цели преследует.
      # сделаем тут пока самое простое..для наших данных ))

      def parse_path(path_route, path_params)
        array_route = @path.split('/').reject(&:empty?)
        array_request = path_params.split('/').reject(&:empty?)
        # 1 )
        return true if array_route == array_request
        # 2
        return true if array_route.size == array_request.size && array_route[-1] == ':id' && array_request[-1].to_i > 0
        # 3)
        false
      end
    end
  end
end

