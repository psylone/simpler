module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        # @path = path
        @path = path_regexp(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        # @method == method && path.match(@path)
        @method == method && path =~ @path
      end

      def set_params(env, path)
        env['simpler.params'] = @path.match(path).named_captures.transform_keys!(&:to_sym)
      end

      private

      def path_regexp(path)
        regex = path.split('/').map { |part| part.start_with?(':') ? "(?<#{part.delete_prefix(':')}>\\w+)" : part }.join('/')

        Regexp.new('^' + regex + '$')
      end
    end
  end
end
