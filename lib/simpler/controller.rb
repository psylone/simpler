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
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
        body = render_body

        @response.write(body)
    end

    def render_body
      @request.env['simpler.template'] || View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def render(template)
      type_template = template.keys.first
      case type_template
      when :plain then plain(template[type_template])
      else
        @request.env['simpler.template'] = template
      end
    end

    def plain(text)
      headers['Content-Type'] = 'text/plain'
      @request.env['simpler.template'] = text
    end

    def set_status_code(code)
      @response.status = code
    end

    def headers
      @response.header
    end
  end
end
