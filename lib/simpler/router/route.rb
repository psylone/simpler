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
        router_parts = @path.split('/') 
        request_parts = path.split('/') 

        return false if router_parts.size != request_parts.size

        router_parts.each_index do |index|
          unless router_parts[index] == request_parts[index] 
            match_data = router_parts[index].match(/^:(.+)/)

            return false if match_data.nil?

            params[match_data[1].to_sym] = request_parts[index]
          end
        end

        env['simpler.params'] = params
      end

    end
  end
end
