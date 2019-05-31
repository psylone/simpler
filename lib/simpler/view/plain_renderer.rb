require_relative 'renderer'
module Simpler
  class PlainRenderer < Renderer
    def initialize(text)
      @text = text
    end

    def render(binding)
      @text
    end

    def type
      'text/plain'
    end
  end
end
