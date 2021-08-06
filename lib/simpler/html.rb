require_relative 'viewable'

module Simpler
  class View
    class Html
      include Simpler::Viewable

      VIEW_BASE_PATH = 'app/views'.freeze

      def initialize(env)
        @env = env
      end

      def render(binding)
        template_file = File.read(template_path)
        ERB.new(template_file).result(binding)
      end

      private

      def template_path
        path = template || [controller.name, action].join('/')

        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      end
    end
  end
end
