module Simpler
  class View
    class PlainRenderer

      def initialize(env)
        @env = env
      end

      def render(binding)
        "#{@env['simpler.template'][:plain]}"
      end
    end
  end
end
