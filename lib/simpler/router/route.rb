# frozen_string_literal: true

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
        @method == method && match_path?(path)
      end

      def params(request_path)
        route_parts = parts(@path)
        request_parts = parts(request_path)

        route_parts.zip(request_parts).each.with_object({}) do |(path, request), result|
          next unless path.start_with?(':')

          result[path.delete(':').to_sym] = request
        end
      end

      private

      def match_path?(path)
        route_parts = parts(@path)
        request_parts = parts(path)

        return false if request_parts.size != route_parts.size

        route_parts.zip(request_parts).all? do |path_part, request_part|
          path_part.start_with?(':') || path_part == request_part
        end
      end

      def parts(path)
        path.split('/').drop(1)
      end
    end
  end
end
