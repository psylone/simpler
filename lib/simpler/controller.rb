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
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.update(@request.env['simpler.route_params'])
    end

    def render(template)
      @request.env['simpler.template'] = template

      if template.is_a?(Hash)
        case template.keys.first
          when :plain
            @response['Content-Type'] = 'text/plain'
        end
      end
    end

    def status(number)
      @response.status = number
    end

    def headers(header_name, value)
      @response["#{header_name}"] = "#{value}"
    end

  end
end
