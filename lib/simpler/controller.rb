require_relative 'view'

module Simpler
  class Controller

    CONTENT_TYPES = {
      html: 'text/html',
      plain: 'text/plain'
    }

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
      set_template_type
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      method = "render_#{@request.env['simpler.template.type']}"

      View.new(@request.env).send(method, binding)
    end

    def params
      @request.env['simpler.params'].merge(@request.params)
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response.headers
    end

    def render(template)
      if template.is_a? Hash
        type = CONTENT_TYPES.fetch([template.keys[0]], 'text/plain')
        body = template.values[0]

        @response['Content-Type'] = type
        @request.env['simpler.template.body'] = body
      else
        @request.env['simpler.template.body'] = template
      end

      set_template_type
    end

    def set_template_type
      @request.env['simpler.template.type'] = CONTENT_TYPES.key(@response.content_type)
    end
  end
end
