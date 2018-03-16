require 'byebug'
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
      set_default_status
      send(action)
      write_response

      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = @response['Content-Type']

      @response.finish
    end

    def not_found_response
      status 404
      header 'plain/html'
      render 'public/404'
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

    def set_default_status
      status 200
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

    def render(render_params)
      @request.env['simpler.template'] = render_params if render_params.is_a?(String)
      @request.env['simpler.plain_response'] = render_params[:plain] if render_params.is_a?(Hash)
    end

    def status(new_status)
      @response.status = new_status
    end

    def header(new_header)
      @response['Content-Type'] = new_header
    end

  end
end
