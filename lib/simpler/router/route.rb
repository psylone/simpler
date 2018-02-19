module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        app_path_segments = parse_route(@path)
        path_segments = parse_route(path)

        @method == method && path_match(app_path_segments, path_segments)
      end

      private

      def self.actions(action)
        @actions ||= []
        @actions << action
        @actions = @actions.uniq
      end

      def self.get_actions
        @actions
      end

      def parse_route(path)
        path.split('/').reject!(&:empty?)
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

      def param?(element)
        element.start_with?(':')
      end

      def action?(path_element)
        self.class.get_actions.include? path_element
      end

      def set_route_params(element, path_element)
        element = element.delete(":").to_sym
        @params[element] = path_element
      end

      def equal_size?(app_path_segments, path_segments)
        app_path_segments.size == path_segments.size
      end

    end
  end
end
