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

      @request.env['simpler.response'] = @response.finish
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
       if @request.env['simpler.template'] != 0
         View.new(@request.env).render(binding)
       end
    end

    def status(status)
      @response.status = status
    end

    def headers(headers)
      headers.each do |k, v|
        key = k.to_s.split(/_/).map(&:capitalize).join("-")
        @response[key] = v
      end
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      #нужно исправить render method
      if template.is_a?(Hash)
        render_handler(template)
        @request.env['simpler.template'] = 0
      else
        @request.env['simpler.template'] = template
      end
    end

    def render_handler(t)
      @response.write(t[:plain])
    end

  end
end
