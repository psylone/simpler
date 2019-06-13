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
      @response['Content-Type'] = "text/html"
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
      if template.instance_of?(Hash)
        rendering_type = template.keys[0]
        rendering_content = template.values[0]
        set_content_type(rendering_type)
        @request.env['simpler.template'] = rendering_content
      else
        @request.env['simpler.template'] = template
      end
    end

    def set_content_type(rendering_type)
      case rendering_type
      when :html, :plain, :xml
        @response['Content-Type'] = "text/#{rendering_type}"
      when :json
        @response['Content-Type'] = "application/#{rendering_type}"
      end
    end

  end
end
