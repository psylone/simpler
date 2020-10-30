module Simpler
  class View
    class Plain
      def initialize(template)
        @template = template
      end

      def result(_binding)
        @template
      end
    end
  end
end 
