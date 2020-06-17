module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && check?(path)
      end

      def check?(path)
        if path == @path
          true
        elsif(@path.include?(':'))
          check(path) == path
        else
          false
        end
      end

      def check(path)
        app_path = @path.split('/')
        request_path = path.split('/')
        @params_key_value = {}

        if app_path.size == request_path.size
          app_path.size.times do |i| 
            if(app_path[i] != request_path[i] && app_path[i].include?(':'))
              @params_key_value[app_path[i].delete(':')] = request_path[i]
              app_path[i] = request_path[i]
            end
          end

          app_path.join('/')
        end
      end

      def params
        @params_key_value
      end
    end
  end
end
