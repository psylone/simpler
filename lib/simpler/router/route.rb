module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path_reg = get_reg_path(path)
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        path_match = path.match(@path_reg)
        return false unless @method == method && path_match

        @params = path_match.named_captures
        true
      end
      
      private

      def get_reg_path(path)
        Regexp.new "^#{path.gsub(/(:\w+)/, '(?<\1>\w+)').delete(':')}$"
      end
      
    end
  end
end
