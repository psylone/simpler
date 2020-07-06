require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @request.env['simpler.params'] = @request.params.merge!(id: record)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def set_content_type(content_type)
      @response['Content-Type'] = content_type
    end

    # https://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def set_status(code)
      @response.status = code
    end

    def set_headers(headers)
      headers.each { |key, value| @response[key] = value }
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html' if @response['Content-Type'].blank?
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

    def render(template)
      if options[:plain]
        @response['Content-Type'] = 'text/plain'
        @request.env['simpler.plain'] = options[:plain]
      elsif template
        @request.env['simpler.template'] = template
      end
    end
    
    def record
      @request.path_info.gsub(/[^\d]/, '')
    end
  end
end
