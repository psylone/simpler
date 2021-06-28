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
        env['simpler.route_params'] = ''

        counter = 0
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']
        if @method == method
          return true if @path == path
          
          @path_temp = @path.split('/').reject { |item| item == '' }
          path = path.split('/').reject { |item| item == '' }
          @path_temp.each_with_index do |value, index|
            
            if value[0] == ':'
              counter += 1
              env['simpler.route_params'] = {value[1..-1].to_sym => path[counter]}
            end
          end
          !counter.zero?
        end
        
      end

    end
  end
end
