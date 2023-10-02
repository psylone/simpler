require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :status

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      set_default_status
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_status
      status 200
    end

    def status(code)
      @response.status = code
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def headers
      @response.headers
    end

    def write_response
      body = render_body
      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = headers['Content-Type']

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def render(template) 
      @request.env['simpler.template'] = template 
    end

  end
end
