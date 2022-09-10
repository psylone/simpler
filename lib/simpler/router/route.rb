# frozen_string_literal: true

module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = find_params
      end

      def match?(method, path)
        return false if @method != method

        path_match?(path)
      end

      private

      def path_match?(path)
        request_attr = split_path(path)
        route_attr = split_path(@path)

        return false if request_attr.size != route_attr.size

        route_attr.zip(request_attr).all? do |route, request|
          @params[route.delete_prefix(':').to_sym] = request if route[0] == ':'
          request == route || route[0] == ':'
        end
      end

      def find_params
        @params = {}
        params = split_path(@path).select { |attr| attr[0] == ':' }
        params.each { |attr| @params[attr.delete_prefix(':').to_sym] = nil } unless params.empty?
        @params
      end

      def split_path(path)
        path.split('/')[1..-1]
      end
    end
  end
end
