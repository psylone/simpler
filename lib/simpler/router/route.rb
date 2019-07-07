module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = parse_path(path)
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        path_match = path.match(@path)

        return false unless @method == method && path_match

        @params = path_match.named_captures.map{ |k,v| [k.to_sym, v.to_i] }.to_h
        true
      end

      private

      def parse_path(path)
        "\\A#{path.gsub(/(:\w+)/, '(?<\1>\d+)').delete(':')}\\Z"
      end

    end
  end
end
