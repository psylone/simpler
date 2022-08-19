require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env, route_params = {})
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      params.merge!(route_params)
    end

    def make_response(action)

        @request.env['simpler.route_error'] = true if !action
        @request.env['simpler.controller'] = self
        @request.env['simpler.action'] = action

        set_default_headers
        send(action) if action
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

    def set_plain_text_header
      @response['Content-Type'] = 'text/plain'
    end

    def set_response_status(status = 200)
      @response.status = status
    end

    def write_response
      if @request.env['simpler.route_error']
        set_plain_text_header
        set_response_status(404)
        body = "No such page: #{@request.path}"
      elsif @request.env['simpler.plain_text']
        set_plain_text_header
        set_response_status(201)
        body = @request.env['simpler.plain_text']
      else
        body = render_body
      end

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params 
    end

    def render(template)
      if template.is_a?(Hash)
        @request.env['simpler.plain_text'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end