module Simpler
  class View
    class PlainRender
      def initialize(env)
        @env = env
      end

      def render(binding)
        @env['simpler.template.plain'].to_s
      end
    end
  end
end
