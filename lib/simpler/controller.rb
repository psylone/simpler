require_relative 'view'
require 'json'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env, params = {})
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @request.params.merge!(params)
      @render_mode = :view
      @render_content = binding
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.template'] = [name, action].join('/')

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def response_404
      @response.status = 404
      @response.finish
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response.headers
    end

    def params
      @request.params
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name]&.downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = send("render_#{@render_mode}", @render_content)

      @response.write(body)
    end

    def render(options)
      mode, content = options.first

      @render_mode = mode
      @render_content = content
    end

    def render_view(binding)
      View.new(@request.env).render(binding)
    end

    def render_plain(content)
      @response['Content-Type'] = 'text/plain'
      @request.env.delete('simpler.template')
      content
    end

    def render_template(template)
      @request.env['simpler.template'] = template
      render_view(binding)
    end

    def render_json(content)
      @response['Content-Type'] = 'application/json'
      @request.env.delete('simpler.template')
      content.to_json
    end
  end
end
