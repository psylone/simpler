require 'erb'

module Simpler

  class DefaultRenderer
    def initialize(path)
      full_path = Simpler.root.join(View::VIEW_BASE_PATH, "#{path}.html.erb")
      @template = File.read(full_path)
    end

    def render(binding)
      ERB.new(@template).result(binding)
    end
  end
end
