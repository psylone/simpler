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
      @response['X-Controller'] = self.class.name
      @response.finish
    end


    private

    def set_header(option)
      @response[option.key] = option.value
    end

    def set_status(status)
      @response.status = status
    end

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

    def render(template)
      if template.is_a?(Hash)
        @response['Content-Type'] = 'text/plain'
        @request.env['simpler.plain'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

    def respond_to
      @text_type = @request.get_header('Content-Type').split('/').last
    end
  end
end
