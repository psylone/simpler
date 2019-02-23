module Simpler
  class View
    class PlainRenderer

      attr_reader :content, :header

      def initialize(template, bind)
        @template = template
        @binding = bind
        @header  = 'text/plain'
      end

      def render
        @content = @template
      end
    end
  end
end
