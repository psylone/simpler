module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :param_name

      def initialize(method, path, controller, action, param_name)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @param_name = param_name

        replace_path_for_param_name
      end

      def match?(method, path)
        @method == method && path.match(Regexp.new("^#{@path}$"))
      end

      private

      def replace_path_for_param_name
        @path.sub!(@param_name, '[0-9]+') if @param_name
      end

    end
  end
end
