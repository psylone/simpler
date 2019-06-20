module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
      Dir["#{Simpler.root}/lib/simpler/view/**/*.rb"].each { |file| require file }
    end

    def render(binding)
      get_render.new(@env).result(binding)
    end

    private

    def get_render
      if @env['simpler.render_type'].is_a?(Hash)
        type = @env['simpler.render_type'].keys.first
      else
        type = 'html'
      end

      Object.const_get("Simpler::#{type.capitalize}Render")
    end
  end
end
