require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :params

    def initialize(env, params)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @params = params || {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      result = render_body
      headers['Content-Type'] = result.last
      @response.write(result.first)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      @request.env['simpler.template'] = template
    end
  end
end
