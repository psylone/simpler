require 'erb'

require_relative 'view/html'
require_relative 'view/plain'
require_relative 'view/json'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      view_name = to_view_name(content_type)
      view = get_view_name(view_name)

      view.new(@env).render(binding)
    end

    private

    def content_type
      @env['simpler.content_type']
    end

    def to_view_name(name)
      "Simpler::View::#{name.capitalize}"
    end

    def get_view_name(name)
      view_validate!(name)

      Object.const_get(name)
    end

    def view_available?(name)
      Object.const_defined?(name)
    end

    def view_validate!(name)
      raise "Can't render type #{content_type}" unless view_available?(name)
    end

  end
end
