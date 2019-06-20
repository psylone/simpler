require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      params.each { |key, value| @request.update_param(key.to_sym, value.to_i)}

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def status(code)
      @response.status = code
    end

    def header(key, v)
      @response.set_header(key, v)
    end

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
      @request.params
    end

    def render(type_hash)
      @request.env['simpler.render_type'] = type_hash
    end

  end
end
