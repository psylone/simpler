require_relative 'view'
require 'byebug'

module Simpler
  class Controller

    RENDER_OPTIONS = {plain: 'text/plain', html: 'text/html'}

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
      env['ROUTE_PARAMS'].each { |k,v| params[k] = v }
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      @request.env['simpler.template'] ||= action
      write_response(action) if @response.body.empty?

      @response.finish
    end

    def render(render_params)
      if render_params.is_a?(Hash)
        template = render_params.first
        set_custom_headers(template)
        @response.write(View.new(@request.env).send(template.first, template.last))
      else
        @request.env['simpler.template'] = render_params.to_s
      end
    end

    def status(number)
      @response.status = number
    end


    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_custom_headers(template)
      if RENDER_OPTIONS.key?(template.first)
        @response['Content-Type'] = RENDER_OPTIONS[template.first]
      else
        raise 'wrong render option'
      end
    end

    def write_response(action)
      body = render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end


  end
end
