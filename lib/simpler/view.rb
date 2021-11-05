require 'erb'
require_relative 'view/template'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
      @template = template
    end

    def render(binding)
      ERB.new(@template.body).result(binding)
    end

    private

    def template
      Template.new(@env)
    end

  end
end
