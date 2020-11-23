require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @request.env['simpler.type_render'] = :erb
      @response = Rack::Response.new
      set_default_headers
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      write_response

      @response.finish
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response.headers
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
      route_params = @request.env['Simpler.Route.Params']
      route_params ||= {}
      @request.params.merge(route_params)
    end

    def render(params)
      case params
      when String
        @request.env['simpler.template'] = params
      when Hash
        if params[:plain]
          @request.env['simpler.type_render'] = :plain
          headers['Content-Type'] = 'text/plain'
          @request.env['simpler.plain'] = params[:plain]
        end
      end
    end

  end
end
