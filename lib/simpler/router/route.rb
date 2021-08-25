module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def self.not_found
        new(:get, '/404', Controller, 'not_found')
      end

      def match?(method, path)
        @method == method && path.match(regexp_for_path)
      end

      def regexp_for_path
        Regexp.new('^'+@path.gsub(/:id/, '\d+')+'$')
      end

    end
  end
end
