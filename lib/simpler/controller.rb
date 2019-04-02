require_relative 'view'

module Simpler
  class Controller

    CONTENT_TYPES = {plain: 'text/plain', html: 'text/html'}.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      write_response
      set_default_headers

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      content_type = @request.env['simpler.template_type']
      @response['Content-Type'] = CONTENT_TYPES[content_type] || CONTENT_TYPES[:html]
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      if template.class == Hash
        template_type = template.keys[0]
        @request.env['simpler.template_type'] = template_type
        @request.env['simpler.template'] = template[template_type]
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(code)
      @response.status = code
    end

  end
end
