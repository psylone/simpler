require_relative 'viewable'

module Simpler
  class View
    class Plain
      include Viewable

      def initialize(env)
        @env = env
      end

      def render(binding)
        template
      end

    end
  end
end
