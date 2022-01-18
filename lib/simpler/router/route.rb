# frozen_string_literal: true

module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && path_check(path)
      end

      private

      def path_check(path)
        path_request = path.split('/').reject!(&:empty?)
        path_router = @path.split('/').reject!(&:empty?)

        return false if path_router.size != path_request.size

        path_router.each_with_index do |component, index|
          if param?(component)
            add_params(component, path_request[index])
          else
            return false unless component == path_request[index]
          end
        end
      end

      def param?(component)
        component.start_with?(':')
      end

      def add_params(param, value)
        param = param.delete(':').to_sym
        @params[param] = value
      end
    end
  end
end
