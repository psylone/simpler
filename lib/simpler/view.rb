# frozen_string_literal: true

require 'erb'
require_relative 'views/render_html'
require_relative 'views/render_plain'

module Simpler
  class View
    RENDERINGS = { html: RenderHtml, plain: RenderPlain }.freeze

    def self.render(env, binding)
      return unless RENDERINGS[env['simpler.template']]

      rendering = RENDERINGS[env['simpler.template']]
      rendering.new(env).render(binding)
    end
  end
end
