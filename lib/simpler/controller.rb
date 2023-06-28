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
      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = @response['Content-Type']

      @response.finish
    end

    def status(code)
      @response.status = code
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
      @request.env['simpler.request.params'].merge!(@request.params)
    end

    def render(template)
      if template.instance_of?(String)
        @response['Content-Type'] = 'text/html'
      elsif template.instance_of?(Hash) && template.keys[0] == :plain
        @response['Content-Type'] = 'text/plain'
      end

      @request.env['simpler.template'] = template
    end
  end
end
