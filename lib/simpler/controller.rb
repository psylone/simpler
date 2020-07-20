require_relative 'view'

module Simpler
  class Controller

    attr_accessor :status
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @response.status = 200
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

    def mime_type(type)
      @response['Content-Type'] = case type
                                  when :plain
                                    'text/plain'
                                  else
                                    'text/html'
                                  end
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
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
      raise "Expected 1 argument, passed #{options}" if options.keys.length != 1

      @request.env['simpler.template'] = options[:template]
      @request.env['simpler.plain'] = options[:plain]
      mime_type(options.keys[0])
    end

    def status(code)
      raise "Invalid code #{code}" unless Rack::Utils::HTTP_STATUS_CODES.key?(code)

      @response.status = code
    end
  end
end
