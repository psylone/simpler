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

      send(action)
      write_response
      set_header

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
      renderer = View.renderer(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def req_params
      @request.params.update(@request.env['simpler.route_params'])
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def set_headers(key, value)
      @response[key] = value
    end

    def set_status(code)
      @response.status = code
    end

    def set_header
      template = @request.env['simple.template']

      if template.is_a? Hash
        case template.key.first
        when :plain
          set_headers('Content-Type', 'text/plain')
        when :html
          set_headers('Content-Type', 'text/html')
        end
      end
    end
  end
end
