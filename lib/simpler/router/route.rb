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

        self.class.actions(action)
      end

      def match?(method, path)
        app_path_segments = parse_route(@path)
        path_segments = parse_route(path)

        @method == method && path_match(app_path_segments, path_segments)
      end

      private

      def self.actions(action)
        @@actions ||= []
        @@actions << action
      end

      def parse_route(path)
        path.split('/').reject! { |elem| elem.empty? }
      end

      def path_match(app_path_segments, path_segments)
        return false unless equal_size?(app_path_segments, path_segments)

        app_path_segments.each_with_index do |element, index|
          if param?(element, path_segments[index]) && !action?(path_segments[index])
            set_route_params(element, path_segments[index])
            next
          end
          return false unless element == path_segments[index]
        end    
        true
      end

      def param?(element, path_element)
        element.start_with?(':')
      end

      def action?(path_element)
        @@actions.include? path_element
      end
      
      def set_route_params(element, path_element)
        element = element.delete(":").to_sym
        @route_params[element] = path_element.to_i
      end

      def equal_size?(app_path_segments, path_segments)
        app_path_segments.size == path_segments.size
      end

    end

  end

end
