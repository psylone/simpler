module Simpler
  class PlainRender
    def initialize(env)
      @env = env
    end

    def result(binding)
      @env['simpler.render_type'].values.first
    end
  end
end
