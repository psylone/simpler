require 'erb'

module Simpler
  class View
    class ErbRender < BaseRender
      def render(binding)
        ERB.new(template).result(binding)
      end
    end
  end
end
