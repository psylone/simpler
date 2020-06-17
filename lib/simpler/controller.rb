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
      set_headers 'text/html'
    end

    def set_headers(header)
      @response['Content-Type'] = header
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).check_format(binding)
    end

    def params
      @request.env['simpler.params'] = @request.params.merge(id: @request.env["simpler.params"])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def set_status(response_status)
      @response.status = response_status
    end
  end
end
