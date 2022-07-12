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

      set_headers
      set_status      
      send(action)
      write_response

      @response.finish
    end

    def set_status(status = nil)
      case @request.request_method
      when 'GET'
        @response.status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
      when 'POST'
        @response.status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:created]
      end
      
      @response.status = status unless status.nil? 
    end

    def set_headers(type = 'text/html')
      @response['Content-Type'] = type
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
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
