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
      @response['Content-Type'] = 'text/html'
    end

    def set_status(status)
      @request.status = status
    end

    def set_headers(headers)
      headers.each {|key, value| @response[key] = value}
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
        @request.env['simpler.plain_text'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end
  end
end
