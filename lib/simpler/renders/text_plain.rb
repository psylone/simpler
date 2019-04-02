module Simpler
  class TextPlainRender
    def initialize(env)
      @env = env
    end

    def render(_binding)
      @env['simpler.template']
    end
  end
end
