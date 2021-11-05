module Simpler
  class View
    class Template
      attr_reader :body

      def initialize(env)
        @env = env
        @body = build_body
      end

      private

      def build_body
        if template.respond_to?(:key)
          parse_template
        else
          defoult_body
        end
      end

      def defoult_body
        path = template || [controller.name, action].join('/')
        full_path = Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
        File.read(full_path)
      end

      def parse_template
        template[:plain] if template.key?(:plain)
      end

      def controller
        @env['simpler.controller']
      end

      def action
        @env['simpler.action']
      end


      def template
        @env['simpler.template']
      end


      #def template_path
      #  path = template || [controller.name, action].join('/')

      #  Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      #end

    end
  end
end

