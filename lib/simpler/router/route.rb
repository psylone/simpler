module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = []
      end

      def match?(method, path)
        match_data = path.match(regex_for_route_path(@path))
        if match_data
          @params = match_data&.named_captures.map {|k, v| [k.to_sym, v] }.to_h
        end

        @method == method && match_data
      end

      private

      def regex_for_param(param_name)
        param_name.delete!(":")
        "(?<#{param_name}>(\\d*))"
      end

      def regex_for_route_path(path)
        regex_part = path
          .split("/")
          .map {|el| el[0] == ":" ? regex_for_param(el) : el }
          .join("/")

        "^#{regex_part}/?$"
      end
    end
  end
end
