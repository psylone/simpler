# frozen_string_literal: true

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
      View.new(@request.env).render(binding)
    end

    def headers
      @response
    end

    def params
      @request.env['resource.ids']
    end

    def status(code)
      @response.status = code
    end

    def custom_render(format)
      @response['Content-Type'] = format.header
      @response.write(format.body)
    end

    def render(template)
      if template.is_a?(Hash)
        format = Render.new(template).call
        custom_render(format)
      else
        @request.env['simpler.template'] = template # это не хэш а метод квадратные скобки
      end
    end
  end
end
