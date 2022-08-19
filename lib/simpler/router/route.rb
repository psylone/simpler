module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @route_params = {}
      end

      def match?(method, path)
        return false if @method != method 

        sample = @path.split('/').map { |pth| pth.include?(':') ? pth[1...].to_sym : pth }

        if (path =~ /#{sample.map { |pth| pth.is_a?(Symbol) ? "[^\/]+" : pth }.join('\/')}[\/]*$/)
          path = path.split('/')
          sample.each_with_index { |v, i| @route_params[v] = path[i] if v.is_a?(Symbol) }
        else
          false
        end
      end

    end
  end
end
