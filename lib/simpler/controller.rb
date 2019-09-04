require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    CONTENT_TYPE = { plain: 'text/plain', html: 'text/html' }.freeze

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

    def content_type
      @request.env['simpler.template'].nil? ? :html : @request.env['simpler.template'].keys.first
    end

    def set_default_headers
      @response['Content-Type'] ||= CONTENT_TYPE[content_type]
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
        plain(template[:plain])
      else
        @request.env['simpler.template'] = template
      end
    end

    def plain(text)
      @response.write(text)
      @response['Content-Type'] = 'text/plain'
    end

  end
end
