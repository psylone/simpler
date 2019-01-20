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
      @request.env['simpler.params'].merge!(@request.params)

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
      if @response.body.empty?
        body = render_body

        @response.write(body)
      end
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      type_template = template.keys.first
      case type_template
      when :plain then plain(template[type_template])
      when :json  then json(template[type_template])
      else
        @request.env['simpler.template'] = template
      end
    end

    def plain(text)
      @response.write(text)
      @response['Content-Type'] = 'text/plain'
    end

    def json(text)
      @response.write(text)
      @response['Content-Type'] = 'application/json'
    end

    def set_status_code(code)
      @response.status = code
    end

    def headers(type)
      @response.header['Content-Type'] = type
    end
  end
end
