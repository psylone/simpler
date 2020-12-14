module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = make_path(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && @path =~ path
      end

      def inject_params!(env, path)
        match_data = @path.match(path)
        env['Url-Params'] = match_data.named_captures.transform_keys!(&:to_sym) # {:id=>\"101\"}
      end

      private

      def make_path(path)
        regex_s = path.split('/')
          .map { |path_part| path_part.start_with?(':') ? "(?<#{path_part[1..]}>[a-z0-9]+)" : path_part }
          .join('/') + '$'

        Regexp.new(regex_s, Regexp::IGNORECASE) # (\/tests\/(?<id>[a-z0-9]+)$)
      end

    end
  end
end
