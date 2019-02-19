module Simpler
  class Views
    class PlainRender

      def initialize(template)
        @template = template
      end

      def result(_binding)
        @template
      end
    end
  end
end
