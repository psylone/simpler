require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :view,  :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.render_template'] = { html: 'Default!'}
      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def status(code)
      @response.status = code
    end

    def headers
      @response.headers
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      @response.write(render_body)
      @response['Content-Type'] = view.renderer.header
    end

    def render_body
      @view = View.new(@request.env)

      @view.render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def render(template)
      @request.env['simpler.render_template'] = template
    end
 end

end
