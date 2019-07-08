# frozen_string_literal: true

require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(request)
      @name = extract_name
      @request = request
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

    def set_headers
      @response.headers
    end

    private

    def set_status(number_status)
      @response.status = number_status
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body + "\n")
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      @request.env['simpler.template'] = template
    end
  end
end
