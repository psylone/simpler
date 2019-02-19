require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @type_render = nil
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
      set_header('Content-Type', 'text/html')
    end

    def set_header(key, v)
      @response.headers[key] = v
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding, @type_render)
    end

    def params
      @request.params.merge(@request.env['simpler.route_params'])
    end

    def render(template)
      if template.keys.first == :plain
        status(template[:status])

        set_header('Content-Type', 'text/plain')
        @type_render = 'plain'
        @request.env['simpler.template'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(value)
      @response.status = value || 200
    end
  end
end
