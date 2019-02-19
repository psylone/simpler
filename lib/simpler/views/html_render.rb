module Simpler
  class Views
    class HtmlRender

      def initialize(path)
        @path = path
      end

      def result(binding)
        template = File.read(@path)

        ERB.new(template).result(binding)
      end
    end
  end
end
