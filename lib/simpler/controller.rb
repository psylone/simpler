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

      get_params
      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def status(code)
      @response.status = code
    end

    def set_header(name, value)
      @response[name] = value
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

    def get_params
      @request.params['method'] = @request.env['REQUEST_METHOD']
      @request.env['simpler.params'].each do |param_key, param_value|
        @request.params[param_key] = param_value
      end
    end

    def render(bindings)
      @request.env['simpler.template'] = bindings
    end
  end
end
