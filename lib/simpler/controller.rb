require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @request.params.merge!(env['params'])
      @response = Rack::Response.new
      @already_rendered = false
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
      @already_rendered = true
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render_string(template)
      @request.env['simpler.template'] = template
    end

    def render_error(error_message)
      status 500
      @response.write(error_message)
      @response.finish
    end

    def render_hash(params)
      if params.key?(:plain)
        @request.env['simpler.render'] = :plain
        @response.write(params[:plain].to_s)
        @response.finish
      else
        render_error("Cannot render template with #{params.keys} options")
      end
    end

    def status(status)
      response.status = status
    end

    def headers
      @response.headers
    end

    def params
      @request.params
    end

    def render(template)
      case template
      when String
        render_string(template)
      when Hash
        render_hash(template)
      else
        render_error("Cannot render #{template.class} template")
      end
      @already_rendered = true
    end

  end
end
