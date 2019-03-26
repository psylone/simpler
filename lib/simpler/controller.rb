require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env, route_params)
      @route_params = route_params
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

    protected

    def set_header(key,value)
      @response.set_header(key, value)
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
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge(@route_params)
    end

    def render(template_or_response)
      if template_or_response.instance_of?(String)
        @request.env['simpler.template'] = template_or_response
      elsif template_or_response.instance_of?(Hash)
        @request.env['simpler.respond_type'] = template_or_response.keys[0]
        @request.env['simpler.respond_value'] = template_or_response.values[0]
      end
    end
  end
end
