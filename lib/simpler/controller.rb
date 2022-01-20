require_relative 'view'

module Simpler
  class Controller

    HEADERS_TYPES = {html: 'text/html', plain: 'text/plain'}.freeze

    attr_reader :name, :request, :response, :loger

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      request.env['simpler.controller'] = self
      request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      response.finish
    end
    
    private

    def set_request_param
      request.env['REQUEST_PATH'].split('/')[2]
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      set_headers(:html)
    end

    def write_response
      body = render_body

      response.write(body)
    end

    def render_body
      View.new(request.env).render(binding)
    end

    def params
      request.params.merge!(request.env['simpler.params'])
    end

    def render(template)
      if template.is_a?(Hash)
        request.env['simpler.plain_text'] = template.first[1]
      else
        request.env['simpler.template'] = template
      end
    end
    
    def status(status_code)
      response.status = status_code
    end

    def set_headers(type)
      header_type_valid?(type)
      response['Content-type'] = HEADERS_TYPES[type]
      request.env['simpler.content_type'] = type
    end

    def header_type_valid?(type)
      controller_action = "#{self.class.name}##{@request.env['simpler.action']}"
      raise "Unknown content type `#{type}` in #{controller_action}" unless HEADERS_TYPES.key?(type)
    end
  end
end
