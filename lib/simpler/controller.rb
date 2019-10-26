require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      set_params(env)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def set_header(type, header)
      @response[type] = header
    end

    def set_status(status)
      @response.status = status
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
      renderer = View.renderer(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def set_params(env)
      @request.params.update(env['simpler.route_params'])
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end
  end
end
