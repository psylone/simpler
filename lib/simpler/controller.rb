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

      send(action)
      write_response
      set_default_headers

      @response.finish
    end

    def params=(input)
      input.each { |k, v| @request.params[k] = v }
    end

    def params
      @request.params
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response.headers['Content-Type'] ||= 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a?(Hash)
        template.each do |k, v|
          @request.env['simpler.format'] = k
          @request.env['simpler.content'] = v
        end
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(code)
      @response.status = code
    end

    def not_found
      render plain: "Not Found\n"
      status 404
    end
  end
end
