module Simpler
  class View
    class BaseRender
      attr_accessor :template

      def initialize(template)
        @template = template
      end

      def render(binding); end
    end
  end
end
