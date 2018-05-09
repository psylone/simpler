module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, full_path, controller, action, params)
        @method = method
        @path = full_path
        @controller = controller
        @action = action
        @params = params
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

      def path_match(app_path_segments, path_segments)
        return false unless equal_size?(app_path_segments, path_segments)
      
        app_path_segments.each_with_index do |element, index|
          if param?(element) && !action?(path_segments[index])
            set_route_params(element, path_segments[index])
            next
          else
            return false unless element == path_segments[index]
          end
        end
        true
      end

    
    end
  end
end
