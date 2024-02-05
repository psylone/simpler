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

      def match?(method, path, env)
        @method == method && parse_path(path, env)
      end

      private

      def parse_path(path, env)
        params = {}
        request_path = path.split('/')
        router_path = @path.split('/')

        return false if request_path.size != router_path.size

        router_path.each_with_index do |element, index|
          if element.start_with?(':')
            params[element[1..-1].to_sym] = request_path[index]
          else
            return false unless element == request_path[index]
          end
        end
        env['simpler.params'] = params
      end

    end
  end
end
