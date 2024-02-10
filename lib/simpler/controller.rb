require_relative 'view'

module Simpler
  class Controller

    RENDER_FORMATS = {
      :plain => :render_plain, 
      :json => :render_json,
      :html => :render_html
    }

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
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

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      view = View.new(@request.env)
      @response['Rander-Template-Path'] = view.used_template.to_s
      view.render(binding)
    end

    def params
      @request.params
    end

    def render(parametr)
      @request.env['simpler.template'] = parametr
      # if parametr.is_a?(String)
      #   @request.env['simpler.template'] = parametr
      # elsif parametr.is_a?(Hash)
      #   format_method = RENDER_FORMATS.fetch(parametr.keys.first, :render_error)
      #   format_value = parametr[parametr.keys.first]
      #   self.method(format_method).call(format_value, **args)
      # end
    end

    def render_plain(text, **args)
      @request.env['simpler.template'] = text
    end

    def render_json(text, **args)

    end

  end
end
