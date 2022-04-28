module Simpler
  class Router
    class Route

      REGEXP = { url_show_regexp: /^(\/[^\/]+)\/\d+?$/, show_regexp: /^(\/[^\/]+)\/\:id?$/ }
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && (path.match(@path) && path.length == @path.length || compare_paths(path, @path))
      end

      def compare_paths(url_path, route_path)
        byebug
        contr = url_path.split('/')[1]
        given_contr = route_path.split('/')[1]
        url_path =~ REGEXP[:url_show_regexp] && route_path =~ REGEXP[:show_regexp] && contr.match(given_contr)
      end

      def env_params(url_path)
        { :id => url_path.split('/')[2] }
      end

    end
  end
end
