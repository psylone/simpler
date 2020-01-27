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

      def match?(method, path)
        return if @method != method

        parsed_url = parse(path)
        parsed_path = parse(@path)

        return if parsed_url.size != parsed_path.size

        return if equal_path(parsed_path, parsed_url).include?(false)

        true
      end

      def params(path_from_url)
        parsed_path = parse @path
        parsed_url = parse path_from_url
        parsed_path.map.with_index.with_object({}) do |(p, i), param|
          param[p[1..-1]] = parsed_url[i] if p =~ /\:.+/
        end
      end

      private

      def equal_path(path, route)
        route.map.with_index { |u, i| (u == path[i]) || (path[i] =~ /\:.+/) }
      end

      def parse(path)
        path.split('/').reject(&:empty?)
      end
    end
  end
end
