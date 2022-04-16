require_relative 'viewable'

module Simpler 
  class View
    class Plain

      include Viewable

      VIEW_BASE_PATH = 'app/views'.freeze

      def initialize(env)
        @env = env
      end

      def render(binding)
        template
      end
    end
  end
end