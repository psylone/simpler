require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response
    attr_accessor :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def status(status)
      @response.status = status
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      return hash_template(template) if template.is_a?(Hash)

      @request.env['simpler.template'] = template
    end

    def hash_template(template)
      content_header(template)
      @request.env['simpler.content_type'] = template.keys[0]
      @request.env['simpler.template'] = template.values[0]
    end

    def content_header(template)
      case template.keys[0]
      when :plain then @response['Content-Type'] = 'text/plain'
      end
    end

  end
end
