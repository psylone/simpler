require 'erb'
require 'json'
require 'active_support'
require 'active_support/core_ext'

module Simpler
  module ViewRender
    VIEW_BASE_PATH = 'app/views'.freeze

    private

    def render_template(binding)
      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    def render_plain(_)
      rendering_value
    end

    def render_inline(binding)
      ERB.new(rendering_value).result(binding)
    end

    def render_html(_)
      ERB.new(rendering_value).result
    end

    def render_json(_)
      ERB.new(rendering_value.to_hash.to_json).result
    end

    def render_xml(_)
      ERB.new(rendering_value.to_hash.to_xml).result
    end

    def template_path
      template = type_of_render == :template ? rendering_value : nil

      path = "#{template || [controller.name, action].join('/')}.html.erb"
      @env['simpler.template_path'] = path

      Simpler.root.join(VIEW_BASE_PATH, path)
    end
  end
end
