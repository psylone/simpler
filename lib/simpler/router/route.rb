module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = convert_to_regex(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match?(@path)
      end

      def params(path)
        match_result = @path.match(path)
        match_result && Hash[match_result.names.map(&:to_sym).zip(match_result.captures)]
      end

      private

      def convert_to_regex(path)
        Regexp.new("#{path.gsub(/:(?<param>\w+)/, "(?<\\k<param>>\\w+)")}")
      end
    end
  end
end
