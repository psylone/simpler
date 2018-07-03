require 'erb'

module Simpler
  class View
    class PlainRenderer

      def initialize(env)
        @env = env
      end

      def render(binding)
        @env['simpler.template'][:plain].to_s
      end

    end
  end
end
