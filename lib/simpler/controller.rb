require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = params

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

    def renderer_params(renderer)
      @response['Content-Type'] = renderer.type.to_s
      @request.env['simpler.template'] = renderer.template
    end

    def status(code)
      @response.status = code
    end

    def header(key, value)
      @response.set_header(key, value)
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      view = View.new(@request.env)
      renderer_params(view.renderer)
      view.render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(source)
      @request.env['simpler.render_source'] = source
    end

  end
end
