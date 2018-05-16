require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = @request.params.merge(@request.env['simpler.params'])

      set_default_headers
      send(action)

      write_response

      @response.finish
    end

    def params
      @request.env['simpler.params']
    end

    private

    def change_header
      @response['Content-Type'] = 'text/plain'
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body( @response['Content-Type'])

      @response.write(body)
    end

    def render_body(content_type)
      View.new(@request.env).render(binding, content_type)
    end

    def status(code)
      response.status = code
    end

    def header
      @response
    end

    def render(template)
      if template[:plain]
        change_header
        @request.env['simpler.template_plain'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end
  end
end
