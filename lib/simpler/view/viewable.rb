module Simpler
    module Viewable
  
      def render(binding); end
  
      private
  
      def controller
        @env['simpler.controller']
      end
  
      def action
        @env['simpler.action']
      end
  
      def template
        @env['simpler.template']
      end
  
    end
  end