require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(request)
      @name = extract_name
      @request = request
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

    def params
      @request.params
    end

    protected

    def status(code)
      response.status = code
    end

    def headers
      response.headers
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

  end
end
