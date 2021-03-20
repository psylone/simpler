require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
      @body = nil
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response(@body)

      @response.finish
    end

    def status(code)
      @response.status = code
    end

    def params
      @request.params
    end

    private

    RENDER_FORMATS = { json: 'application/json', plain: 'text/plain' }

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def write_response(body = nil)
      body ||= render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.class == Hash
        format_hash = template.select { |key,value| RENDER_FORMATS.has_key?(key) }
        unless format_hash.empty?
          headers['Content-Type'] = RENDER_FORMATS[format_hash.keys.first]
          @body = format_hash.values.first
        end
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end
