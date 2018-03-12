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

      send(action)
      set_default_headers
      set_content_type
      @response.body = [render_template]
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def render_template
      renderer = View.renderer(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def request_params
      @request.params.update(@request.env['simpler.route_params'])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def status(status)
      @request.status = status
    end

    def headers
      @response.headers
    end

    def set_content_type
      template = @request.env['simpler.template']

      if template.is_a? Hash
        case template.keys.first
          when :text
            headers['Content-Type'] = Rack::Mime.mime_type('.text')
          else
            headers['Content-Type'] = Rack::Mime.mime_type('.html')
        end
      end
    end

  end
end
