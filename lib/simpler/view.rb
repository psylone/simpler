# frozen_string_literal: true

require_relative 'renderer/plain_renderer'
require_relative 'renderer/html_renderer'

module Simpler
  class View
    RENDERERS = { plain: PlainRenderer, html: HTMLRenderer }.freeze
    DEFAULT_RENDERER = RENDERERS[:html]

    def self.renderer(env)
      type = env['simpler.template'].keys.first if env['simpler.template'].is_a? Hash
      env['simpler.action'] = env['simpler.template'] if env['simpler.template'].is_a? String
      RENDERERS[type] || DEFAULT_RENDERER
    end
  end
end
