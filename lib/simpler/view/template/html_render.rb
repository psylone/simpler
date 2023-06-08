module Simpler
  class View
    class HTMLRender
      def initialize(template_path)
        @template_path = template_path
      end

      def result(binding)
        template = File.read(@template_path)
        ERB.new(template).result(binding)
      end
    end
  end
end
