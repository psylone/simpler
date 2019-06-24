module Simpler
  class View
    class PlainRender < BaseRender
      def render(_binding)
        template
      end
    end
  end
end
