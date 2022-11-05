require_relative 'view'

module Simpler
  class Controller
    RENDER_OPTIONS = {
      plain: :render_plain,
      html: :render_html,
      inline: :render_inline
    }.freeze

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      add_custom_headers
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def add_custom_headers
      @headers.each do |k, v|
        @response[k] = v
      end
    end

    def write_response
      body = if RENDER_OPTIONS.keys.include? @request.env['simpler.template']
               send(RENDER_OPTIONS[@request.env['simpler.template']])
             else
               @request.env['simpler.template_path'] = "#{[@name, @request.env['simpler.action']].join('/')}.html.erb"
               render_body
             end

      @response.write(body)
    end

    def render_plain
      @response['Content-Type'] = 'text/plain'
      @render_value
    end

    def render_html
      @response['Content-Type'] = 'text/html'
      @render_value
    end

    def render_inline
      @response['Content-Type'] = 'text/html'
      ERB.new(@render_value).result
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      if template.is_a? Hash
        @request.env['simpler.template'] = template.keys.first
        @render_value = template.values.first
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(status)
      return unless status.between?(100, 599)

      @response.status = status
    end
  end
end
