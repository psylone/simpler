require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response
      @headers.each { |key, value| @response[key] = value }

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @headers['Content-Type'] = 'text/html'
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

    def render(options)
      case options
      when String
        @request.env['simpler.template'] = options
      when Hash
        if options[:plain]
          @headers['Content-Type'] = 'text/plain'
          @request.env['simpler.plain_text'] = options[:plain]
        end
      end
    end

    def status(value)
      @response.status = value
    end

    def headers
      @headers
    end
  end
end
