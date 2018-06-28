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
      @request.env['simpler.parameters'] = params

      send(action)
      set_default_headers if @response["Content-Type"].nil?
      write_response
      @response.finish
    end

    def params
      @request.params
    end

    def set_status(status)
      @response.status = status
    end

    private

    def set_default_headers
      @response["Content-Type"] = "text/html"
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(content_header, type_content)
      @response[content_header] = type_content
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
