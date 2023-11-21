module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params, :path

      def initialize(method, path, controller, action, params)
        @method = method
        @path = params.any? ? path_regexp(path) : path
        @controller = controller
        @action = action
        @params = params
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

      private

      def path_regexp(path)
        Regexp.new(path.split('/').map do |segment|
          segment.start_with?(':') ? "(?<#{segment[1..]}>.+)" : segment
        end.join('/'))
      end
    end
  end
end
