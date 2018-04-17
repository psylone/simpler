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

      def match?(env)
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']

        @method == method && compare_paths(@path, path, env)
      end

      private

      def compare_paths(path_one, path_two, env)
        path_one = path_one.split('/')
        path_two = path_two.split('/')
        env['simpler.params'] = {}

        return false unless path_one.size == path_two.size

        path_one.each_with_index do |el, i|
          env['simpler.params'][el] = path_two[i] if el[0] == ':'

          return false if el != path_two[i] && el[0] != ':'
        end

        true
      end
    end
  end
end
