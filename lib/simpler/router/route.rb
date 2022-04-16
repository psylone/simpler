module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_pattern = to_path_pattern(path)
        @params_pattern = to_params_pattern(path)
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

      def params(path)
        params = path.match(@params_pattren)
        params ? transform_keys(params.named_captures) : {}
      end

      private

      def transform_keys(data)
        transformed_data = {}
        data.each { |key, value| transformed_data[key.to_sym] = value }

        transformed_data
      end

      def to_path_pattern(path)
        Regexp.new("^#{path.gsub(/:([\w_]+)/, '[0-9a-z_]+')}$")
      end

      def to_params_pattern(path)
        Regexp.new("^#{path.gsub(/:([\w_]+)/, '(?<\1>[0-9a-z_]+)')}$")
      end
    end
  end
end
