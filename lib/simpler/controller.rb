require_relative 'view'
require 'byebug'

module Simpler
  class Controller

    HEADERS = {
      plain: "text/plain",
      html: "text/html"
    }

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(type = nil)
      @response['Content-Type'] = HEADERS.fetch(type, 'text/html')
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      view_render = View.render(@request.env)
      view_render.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def status(code)
      @response.status = code
    end

    def header
      @response
    end

    def render(template)
      render = template.is_a?(Hash) ? template : { html: template }
      type = render.keys.first

      set_headers(type)
      @request.env["simpler.template.#{type}"] = render[type]
    end
  end
end
