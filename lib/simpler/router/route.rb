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
        path = __path(path) if entity_action?
        @method == method && path.match("^#{@path}$")
      end

      private

      def entity_action?
        @path.match(':id')
      end

      def __path(path)
        "#{path.split(%r{/\d}).first}/:id"
      end
    end
  end
end
