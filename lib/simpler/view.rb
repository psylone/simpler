require_relative 'renderers/html'
require_relative 'renderers/plain'

module Simpler
  class View

    def self.select_type(env)
      plain_type = nil
      plain_type = env['simpler.template'].keys.first if env['simpler.template'].is_a? Hash
      plain_type.nil? ? HtmlRenderer : PlainRenderer
    end

  end
end
