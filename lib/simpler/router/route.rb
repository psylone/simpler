module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path_reg = get_reg_path(path)
        # @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path, params)
        # @method == method && path.match(@path)

        path_match = path.match(@path_reg)

        if @method == method && path_match
          @params = path_match.named_captures
        else
          false
        end

      end

      private

      def get_reg_path(path)
        Regexp.new "\\A#{path.gsub(/(:\w+)/, '(?<\1>\w+)').delete(':')}\\Z"
      end

    end
  end
end
