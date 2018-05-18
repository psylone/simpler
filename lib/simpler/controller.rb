require 'json'
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

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      template = @request.env['simpler.template']

      if template && template.is_a?(Hash)
        send(template.keys.first, template)
      else
        View.new(@request.env).render(binding)
      end
    end

    def params
      @request.env['simpler.params'].update(@request.params)
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def plain(template)
      @response['Content-Type'] = 'text/plain'
      template[:plain]
    end

    def json(template)
      @response['Content-Type'] = 'application/json'
      template[:json].to_json
    end

    def status(code)
      @response.status = code
    end

    def header
      @response
    end

  end
end
