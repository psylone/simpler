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
      select_format
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
      type = View.select_type(@request.env)
      type.new(@request.env).render(binding)
    end
    
    def add_params
      @params ||= @request.params.update(@request.env['simpler.params'])
    end

    def params
      @request.params
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

    def select_format
      template = @request.env['simpler.template']

      if template.is_a? Hash
        case template.keys.first
        when :plain then @response['Content-Type'] = 'text/plain'
        end
      end
    end

  end
end
