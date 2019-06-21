module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path_regex = get_regex_path(path)
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        path_match = path.match(@path_regex)

        if @method == method && path_match
          @params = path_match.named_captures
        else
          false
        end
      end

      private

      def get_regex_path(path)
        Regexp.new "\\A#{path.gsub(/(:\w+)/, '(?<\1>\d+)').delete(':')}\\Z"
      end

    end
  end
end
