module Simpler
  class View

    class PlainRender
      def initialize(template)
        @template = template
      end

      def result(_binding)
        @template[:plain]
      end
    end
  end
end
