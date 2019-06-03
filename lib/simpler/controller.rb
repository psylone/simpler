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

      set_default_headers
      send(action)
      write_response

      @response.finish
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
      @request.params
    end

    def render(options = {})
      @request.env['simpler.template'] = options.delete(:template)
      @request.env['simpler.template.render'] = options.delete(:format)

      render_inline(options) unless options.keys.empty?
    end

    def render_inline(options)
      format = options.keys.last
      @request.env['simpler.template.render'] = format
      @request.env['simpler.template.inline'] = options[format]
    end

    def headers
      @response
    end

    def status(new_status)
      @response.status = new_status
    end
  end
end
