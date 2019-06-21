module Simpler
  class PlainRender
    def initialize(env)
      @env = env
      @type = 'text/plain'
    end

    def result(binding)
      {type: @type,
       body: @env['simpler.render_type'].values.first,
       template: ''}
    end
  end
end
