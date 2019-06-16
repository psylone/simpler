require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, route_params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.route_params'] = route_params

      set_default_headers unless headers
      set_default_format
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

    def set_default_format
      @request.env['simpler.response_type'] = :html
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def route_params
      @request.env['simpler.route_params']
    end

    def status(code)
      @response.status = code
    end

    def headers(headers = {})
      headers.each do |header, value|
        @response.headers[header] = value
      end
    end

    def render(template_set)
      if template_set.is_a?(Hash)
        format, template = template_set.first

        request.env['simpler.response_type'] = format
        case format
        when :plain
          response['Content-Type'] = 'text/plain'
        when :xml
          response['Content-Type'] = 'text/xml'
        end
        request.env['simpler.template'] = template
      else
        set_default_format
        set_default_headers
        @request.env['simpler.template'] = template_set
      end
    end

  end
end
