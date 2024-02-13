require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      write_response

      @response.finish
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      view = View.new(@request.env)
      @response['Rander-Template-Path'] = view.used_template.to_s
      @response['Content-Type'] = view.content_type.to_s
      view.render(binding)
    end

    def params
      path = '((?<path>.*)/(?<id>\d*))'
      @request.path.match(path)
    end

    def render(parametr)
      @request.env['simpler.template'] = parametr
    end
  end
end
