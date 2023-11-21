require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['params'] = params

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def response_404
      @response.status = 404
      @response.finish
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response.headers
    end

    def params
      @request.env['params']
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name]&.downcase
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

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
