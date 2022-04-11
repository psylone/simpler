require_relative 'view'

module Simpler
  class Controller
    attr_reader :name
    attr_accessor :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
    end

    def make_response(action)
      @request.env['simpler.action'] = action
      @request.env['simpler.controller'] = self

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def params
      @request.env['simpler.params']
    end

    def status(value)
      @response.status = value
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = plain_exists? ? 'text/plain' : 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def plain_exists?
      template = @request.env['simpler.template']

      types = %i[plain inline text body]

      template.is_a?(Hash) && template.any? { |type| types.include?(type) }
    end

    def render_body
      View.new(@request.env).render(binding)
    end
  end
end