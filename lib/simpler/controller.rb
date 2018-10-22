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
      @request.env['simpler.response.header'] = @response.header

      @response.finish
    end

    def not_found_response
      status 404
      header 'Content-Type' => 'plain/html'
      render 'public/404'
      write_response
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      header 'Content-Type' => 'text/html'
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
      case render_params
      when String
        header 'Content-Type' => 'text/html'
      when Hash
        if render_params.keys.include?(:plain)
          header 'Content-Type' => 'plain/text'
        end
        # :json, etc...
      end
      @request.env['simpler.render_params'] = render_params
    end

    def status(new_status)
      @response.status = new_status
    end

    def header(new_header)
      new_header.each { |key, value| @response.set_header(key, value) }
    end

  end
end
