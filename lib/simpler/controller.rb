require_relative 'view'

module Simpler
  class Controller

    RENDER_OPTIONS = {
      plain: :render_plain
    }

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, template)
      if action
        @request.env['simpler.controller'] = self
        @request.env['simpler.action'] = action

        params[:id] = get_param_value(template) if template

        set_default_headers
        send(action)
        write_response
      else
        bad_response
      end

      @response.finish
    end

    private

    def bad_response
      set_default_headers
      status(404)
      @response.write("Page #{@request.env["PATH_INFO"]} not found")
    end

    def get_param_value(template)
      path = @request.env["PATH_INFO"]
      path.delete!(template)
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def write_response
      body = @request.env['simpler.body'] || render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def headers
      @response
    end

    def render(option)
      if option.is_a?(String)
        @request.env['simpler.template'] = option

      elsif RENDER_OPTIONS[option.keys[0]]
        key = option.keys[0]
        send(RENDER_OPTIONS[key], param: option[key])
      end
    end

    def render_plain(param:)
      @request.env['simpler.body'] = param
      @response['Content-Type'] = 'text/plain'
    end

    def status(status)
      @response.status = status
    end

  end
end
