require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze
    DEFAULT_RENDER = 'html'.freeze

    def self.render(env)
      Simpler::View.const_get("#{self.render_type(env).capitalize}Render")
    end

    def self.render_type(env)
      template = env.keys.select { |type| type.match(/simpler.template./) }
      template.any? ? template.first.split('.').last : DEFAULT_RENDER
    end
  end
end
