require_relative 'view'
require_relative 'controller/custom_headers'

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
      params[':id'] = @request.env[':id'] if @request.env[':id']

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def status(code)
      @response.status = code
    end

    def custom_headers
      CustomHeaders.new(@response)
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

    def params
      @request.params
    end

    def render(template)
      if template[:plain]
        @response['Content-Type'] = 'text/plain'
        @request.env['simpler.template'] = template[:plain]
      else
        @response['Conent-Type'] = 'text/html'
        @request.env['simpler.template'] = template
      end
    end

  end
end
