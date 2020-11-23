require_relative 'render'
module Simpler
  class RenderPlain < Render
    def call(binding)
      @env['simpler.plain']
    end
  end
end

