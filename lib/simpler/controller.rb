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
      check_template
      set_default_headers
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

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      renderer = View.renderer(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def request_params
      @request.params
    end

    def params
      @request.params.update(@request.env['simpler.route_params'])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response.headers
    end

    def check_template
      template = @request.env['simpler.template']

      if template.is_a? Hash
        case template.keys.first
        when :plain then headers['Content-Type'] = Rack::Mime.mime_type('.text')
        end
      end  
    end

  end
end
