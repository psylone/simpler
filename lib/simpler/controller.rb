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
      body = @text || render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      template.class == Hash ? render_format(template) : @request.env['simpler.template'] = template
    end

    def render_format(template)
      @text = "#{template[:plain]}\n" if template.has_key?(:plain)
    end

    def set_status(response_status)
      @response.status = response_status
    end
  end
end
