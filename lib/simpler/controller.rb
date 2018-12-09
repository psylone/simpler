require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response
    attr_accessor :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action, variables)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      initialize_variables(variables)

      set_default_headers
      send(action)

      write_response_body
      commit_headers

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def initialize_variables(variables)
      variables.each { |key, value| params[key] = value }
    end

    def set_default_headers
      @headers['Content-Type'] = 'text/html'
    end

    def write_response_body
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template = nil, plain: nil)
      return @request.env['simpler.plain'] = plain if plain
      @request.env['simpler.template'] = template
    end

    def status(code)
      @response.status = code
    end

    def commit_headers
      @headers.each { |key, value| @response[key] = value }
    end

    def error_404
      status 404
      render plain: "Error 404: Not found"
    end
  end
end
