module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_pattern = path_pattern_regexp(path)
        @params_pattern = params_pattern_regexp(path)
      end

      def match?(method, path)
        @method == method && path.match(@path_pattern)
      end

      def params(path)
        params = path.match(@params_pattern)
        hash_params = params.named_captures
        params ? hash_params.transform_keys(&:to_sym) : {}
      end

      private

      def path_pattern_regexp(path)
        Regexp.new("^#{path.gsub(/:([\w_]+)/, '[0-9a-z_]+')}$")
      end

      def params_pattern_regexp(path)
        Regexp.new("^#{path.gsub(/:([\w_]+)/, '(?<\1>[0-9a-z_]+)')}$")
      end

    end
  end
end
