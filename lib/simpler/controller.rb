require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @env = env
      @name = extract_name
      @request = Rack::Request.new(@env)
      @response = Rack::Response.new
      write_params(:id, @env['simpler.id']) if @env['simpler.id']
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)

      write_response

      @env['simpler.logger'].response_msg(status: @response.status,
                                          content_type: @response['Content-Type'],
                                          path: @template_path)

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
      data_from_view = View.new(@request.env).render(binding)
      @template_path = data_from_view[:template_path]

      data_from_view[:data]
    end

    def params
      @request.params
    end

    def write_params(key, value)
      params[key] = value
    end

    def render(template = {})
      if template && template[:plain]
        @request.env['simpler.template-type'] = :plain
        @request.env['simpler.template'] = template[:plain]
        @response['Content-Type'] = 'text/plain'
      elsif template
        @request.env['simpler.template-type'] = :path
        @request.env['simpler.template'] = template
      end
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response.headers
    end
  end
end
