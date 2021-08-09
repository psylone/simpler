require_relative 'view'

module Simpler
  class Controller

    HEADERS_TYPES = {html: 'text/html', plain: 'text/plain'}.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_params
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
      set_headers(:plain)
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a?(Hash)
        @request.env['simpler.plain_text'] = template.first[1]
      else
        @request.env['simpler.template'] = template
      end
    end

    def set_params
      @request.params.merge!(@request.env['simpler.params'])
    end

    def set_status(code)
      @response.status = code
    end

    def set_headers(type)
      header_type_valid?(type)
      @response['Content-type'] = HEADERS_TYPES[type]
      @request.env['simpler.content_type'] = type
    end

    def header_type_valid?(type)
      controller_action = "#{self.class.name}##{@request.env['simpler.action']}"
      raise "Unknown content type `#{type}` in #{controller_action}" if !HEADERS_TYPES.key?(type)
    end
  end
end
