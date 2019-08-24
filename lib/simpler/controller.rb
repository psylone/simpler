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

      query_id

      send(action)
      set_default_headers
      write_response

      # @response.status = 201
      # @response['Content-Type'] = 'text/plain' if self.class.template_plain?(@request.env)

      response = @response.finish
      response[0] = 201 if action == 'create'
      response[1]['Content-Type'] = 'text/plain' if self.class.template_plain?(@request.env)
      response
    end

    def query_id
      id = @request.env['PATH_INFO'].split('/').last.to_i
      @request.params[:id] = id if id > 0
    end

    def self.template_plain?(env)
      env.has_key?('simpler.template') && env['simpler.template'].has_key?(:plain)
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

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
