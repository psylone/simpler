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
      @request.env['simpler.params'] = params
      @request.env['simpler.request_params'] = @request.params

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
      @response['Content-Type'] = 'text/html'
    end

    def set_header(header, format)
      @response[header] = format
    end

    def status(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env, @format).render(binding)
    end

    def params
      @request.env['simpler.route_params'].merge!(@request.params)
    end

    def render(template)
      if template.is_a?(Hash) && template.keys.first == :plain
        set_header('Content-Type', 'text/plain')
        @format = 'plain'
        @request.env['simpler.template'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end
