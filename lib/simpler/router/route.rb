module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def determ_params(env)
        user_path = env['PATH_INFO']
        values = user_path.match(regexp_path)
        keys = @path.gsub(':','').match(regexp_path) 

        @params = Hash[keys.captures.zip(values.captures)]
      end

      private

      def correct_path?(user_path)
        user_path.match?(regexp_path)
      end

      def regexp_path
        Regexp.new (@path.gsub(/(:\w+)/, "(\\w+)") + '\Z')
      end
    end
  end
end
