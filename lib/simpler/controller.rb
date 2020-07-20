require_relative 'view'

module Simpler
  class Controller

    attr_accessor :headers
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @response.status = 200
      @headers = {}
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = params

      set_default_headers
      send(action)
      write_response
      set_custom_headers

      @response.finish
    end

    def params
      @request.env['simpler.params']
    end

    private

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_custom_headers
      @headers.entries.each { |k, v| @response[k] = v }
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


    def render(options)
      if options.is_a?(String)
        plain_text_to_request(options)
      elsif options[:template]
        template_to_request(options[:template])
      elsif options[:plain]
        plain_text_to_request(options[:plain])
      end

    end

    def status(code)
      raise "Invalid code #{code}" unless Rack::Utils::HTTP_STATUS_CODES.key?(code)

      @response.status = code
    end

    def template_to_request(template)
      @request.env['simpler.template'] = template
      @request.env['simpler.template_path'] = "#{template}.html.erb"
      @response['Content-Type'] = 'text/html'
    end

    def plain_text_to_request(text)
      @request.env['simpler.plain'] = text
      @response['Content-Type'] = 'text/plain'
    end
  end
end
