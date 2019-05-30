module Simpler
  class PlainRenderer
    def initialize(text)
      @text = text
    end

    def render(binding)
      @text
    end
  end
end
