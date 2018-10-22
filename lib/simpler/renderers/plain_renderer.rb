require_relative '../renderer'

module Simpler
  class PlainRenderer < Renderer
    
    def render(binding)
      @render_params[:plain]
    end

  end
end
