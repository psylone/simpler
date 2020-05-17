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
        request = Rack::Request.new(env)
        request.params.merge(make_params(env['PATH_INFO']))
      end

      private

      def regexp
        string_for_regexp = "\\A#{@path}\\z".gsub(/:[^\/]+/, '\d+')
        Regexp.new(string_for_regexp)
      end


      def make_params(env_path)
        path = extract_params(@path)
        requests = extract_params(env_path)
        result = {}

        path.zip(requests) do |key, value|
          key = key.delete(':').to_sym
          result[key] = value
        end

        result

        #p result
      end

      def extract_params(string)
        # p string
        string = string.split('/')
        # p string
        string.delete_at(0)
        string
        # p string
      end

    end
  end
end
