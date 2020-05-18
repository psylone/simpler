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
        #require 'pry'
        #binding.pry
        @method == method && regexp.match(path)
      end

      def params(env)
        params = Rack::Request.new(env).params.merge(make_params(env['PATH_INFO']))
      end

      private

      def regexp
        string_for_regexp = "\\A#{@path}\\z".gsub(/:[^\/]+/, '\d+')
        Regexp.new(string_for_regexp)
      end


      def make_params(env_path)
        result = {}
        value = extract_params(env_path)
        key = extract_params(@path).delete(':').to_sym if value
        result[key] = value

        result

        p result
      end

      def extract_params(string)
        string.split('/')[2]
      end

    end
  end
end
