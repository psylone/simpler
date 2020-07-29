 require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @env = env
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      set_default_headers
      @request.params.merge!(@request.env['simpler.params'])

      send(action)
      write_response

      @response.finish
    end

    private

    def status(status_code)
      @response.status = status_code
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      unless @response.body.any?
        body = render_body

        @response.write(body)
      end
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render_plain(plain_text)
      @response.write(plain_text)
      set_plain_header
      @response.finish
    end

    def set_plain_header
      @response['Content-Type'] = 'text/plain'
    end

    def render(template)
      if template.is_a? Hash
        method_name = "render_#{template.keys[0].to_s}"
        send( method_name, template.values[0])
      else
        @request.env['simpler.template'] = template
      end
    end

    def headers
      @response
    end

  end
end
