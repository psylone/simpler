require 'erb'

module Simpler
  class View
    class HtmlRenderer

      attr_reader :content, :header

      def initialize(template, bind)
        @template = template
        @binding = bind
        @header  = 'text/html'
      end

      def render
        @content = ERB.new(@template).result(@binding)
      end

    end
  end
end
