module Simpler
  class Router
    class Route

      K_REGEXP = /:\w+/
      V_REGEXP = /\d+/

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        if path =~ V_REGEXP
          return unless @path =~ K_REGEXP

          key = eval(@path.match(K_REGEXP)[0])  #.sub(':', '').to_sym
          value = path.match(V_REGEXP)[0]
          @params[key] = value

          rule = Regexp.union(@path.gsub(K_REGEXP, ''), V_REGEXP)
          @method == method && path.match(rule)
        else
          @method == method && path.match(@path)
        end
      end

    end
  end
end
