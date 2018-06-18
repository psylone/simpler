require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      ERB.new(work_with_template).result(binding)
    end

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

#     def id_param
#       @env['PATH_INFO'].split("/").last
#     end
#
#     def routing
# end

    def work_with_template
      if template.nil? || template[:plain].nil?
        template_path
      else
        template[:plain].to_s
      end
    end


    def template_path
      path = template || [controller.name, action].join('/')

      File.read(Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb"))
    end

  end
end

# 
#
# require 'erb'
#
# module Simpler
#   class View
#
#     VIEW_BASE_PATH = 'app/views'.freeze
#
#     RENDERERS = {plain: PlainRenderer}
#
#     def initialize(env)
#       @env = env
#     end
#
#     def render(binding)
#       renderer = get_renderer
#       renderer.new(@env).render(binding)
#       # ERB.new(work_with_template).result(binding)
#     end
#
#     private
#
#     def get_renderer
#     end
#
#     def controller
#       @env['simpler.controller']
#     end
#
#     def action
#       @env['simpler.action']
#     end
#
#     def template
#       @env['simpler.template']
#     end
#
# #     def id_param
# #       @env['PATH_INFO'].split("/").last
# #     end
# #
# #     def routing
# # end
#
#     def work_with_template
#       if template.nil? || template[:plain].nil?
#         template_path
#       else
#         template[:plain].to_s
#       end
#     end
#
#
#     def template_path
#       path = template || [controller.name, action].join('/')
#
#       File.read(Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb"))
#     end
#
#
#
#   end
# end
#
