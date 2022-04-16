require_relative 'viewable'

module Simpler 
  class View
    class Json

      include Viewable

      def initialize(env)
        @env = env
      end

      def render(binding)
        JSON.generate(template)
      end
    end
  end
end