module Simpler
  class Router
    class Route

      attr_reader :controller, :params, :action

      def initialize(method, path, controller, action)
        @method = method # :get
        @path = path     # "/tests"
        @controller = controller # TestsController
        @action = action # "index"
      end

      def match?(method, path_params)
        @method == method && parse_path(@path, path_params)
      end

      private

      # погалаю не стоит сейчас тут создавать универсальный алгоритм парсинга под всевозможные варианты.
      # тема текущего урока инные цели преследует.
      # сделаем тут пока что-то самое простое..для наших данных ))

      def parse_path(path_route, path_params)
        @params = {}
        array_route =  path_route.split('/').reject(&:empty?)
        return false if array_route.nil?

        array_params = path_params.split('/').reject(&:empty?)
        return false if array_params.nil?

        return true if array_route == array_params

        return false unless array_route.size == array_params.size

        return false if path_route.index(':').nil?

        array_route.each_with_index do |value, index|
          value_param = array_params[index]
          set_params_format(value, value_param)
        end

        true
      end

      def set_params_format(value, value_param)
        if value.start_with?(':')
          format_pos = (value =~ /\(\.:format\)/).to_i
          dot_params = (value_param =~ /\./).to_i

          key = value[1..format_pos-1]
          @params[key.to_sym] = value_param[0..dot_params-1]

          if format_pos > 0 && dot_params > 0
            @params[:format] = value_param[dot_params+1..-1]
          end
        end
      end

    end
  end
end

