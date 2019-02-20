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
        @method == method && parse_path(path)
      end

      private

      def parse_path(path)
        route_params = split_path(@path)
        request_params = split_path(path)

        return unless route_params.count == request_params.count

        @params = {}
        route_params.each_with_index do |param, index|
          if param.start_with?(':')
            set_param(param, request_params[index])
          else
            return false unless param == request_params[index]
          end
        end
      end

      def split_path(path)
        path.split('/').reject(&:empty?)
      end

      def set_param(param, value)
        param = param.delete!(':').to_sym
        @params[param] = value
      end



    end
  end
end
