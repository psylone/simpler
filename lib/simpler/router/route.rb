module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(request_method, request_path)
        @method == request_method && request_path.match(path_regexp)
      end

      def route_params(request_path)
        params(@request_path) if path_with_params? || {}
      end

      private

      def params(request_path)
        request_path.match(params_regexp).named_captures.transform_keys(&:to_sym)
      end

      def path_with_params?
        @path.match(/\:\w+/)
      end

      def path_match?(request_path)
        request_path.match(@path_regexp)
      end

      def path_regexp
        Regexp.new(@path.gsub(/\:\w+/, '\d+') + '$')
      end

      def params_regexp
        params_regexp = @path.gsub(/\:w+/) do |e|
          "(?<#{e.delete(':')}>\\w+)"
        end
        Regexp.new(params_regexp)
      end

    end
  end
end
