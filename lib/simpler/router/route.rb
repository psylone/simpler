require 'pp'

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
        params = params(path)
        @method == method &&
            path.match(@path.gsub(/\/:[a-z]+/, '')) &&
            match_params?(params)
      end

      def params(request_path)
        return if @path.nil?

        request_uri = request_path.split('/')
        routing_uri = @path.split('/')
        return if request_uri.size != routing_uri.size

        routing_uri.zip(request_uri)
            .filter { |pair| pair[0][/:/] }
            .map { |k, v| [k.gsub(':', '').to_sym, v] }
            .to_h
      end

      def match_params?(params)
        !params.nil? && params.values.all? { |v| !v.nil? }
      end

    end
  end
end
