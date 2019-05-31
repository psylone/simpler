require 'erb'
require_relative 'renderer'

module Simpler

  class DefaultRenderer < Renderer

    def initialize(path)
      @path = path
      @template_path = File.read(
        Simpler.root.join(
          View::VIEW_BASE_PATH,
          template
        )
      )
    end

    def render(binding)
      ERB.new(@template_path).result(binding)
    end

    def template
      "#{@path}.html.erb"
    end
  end
end
