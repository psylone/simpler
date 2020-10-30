require 'erb'

module Simpler
  class View
    class Html
      def initialize(template_path)
        @path = template_path
      end

      def result(binding)
        template = File.read(@path)
        ERB.new(template).result(binding)
      end
    end
  end
end
