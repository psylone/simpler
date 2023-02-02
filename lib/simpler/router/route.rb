module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path_regexp(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @params = define_params(path)

        edited_path = if @params.values.all? && (!@params.values.empty?)
            define_edited_path(path)
          else
            path
          end

        @method == method && edited_path == @path
      end

      private

      def define_params(path)
        route_params_values = []
        route_params_names = []
        path.scan(ROUTE_PARAM_VALUE_REGEXP).each { |param| route_params_values << (param.delete "/") }
        @path.scan(ROUTE_PARAM_NAME_REGEXP).each { |param| route_params_names << param.delete(":").delete("/").to_sym }

        Hash[route_params_names.zip route_params_values]
      end

      def define_edited_path(path)
        edited_path = path
        @params.each { |param_name, param_value| edited_path = edited_path.gsub param_value, ":#{param_name.to_s}" }

        edited_path
      end
    end
  end
end
