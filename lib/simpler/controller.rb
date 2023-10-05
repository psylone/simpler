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
      @request.env['simpler.handler'] = "#{self.class.name}##{action}"

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def params
      @params = route_info.merge!
    end

    def request_params
      @request.params
    end    

    def route_info
      @request.env['simpler.route_info']
    end    

    private

    def headers(content_type, type)
      @response[content_type] = type
    end

    def status(code)
      @response.status = code
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def redirect_to(uri)
      [302, { "Location" => uri }, []]
    end



    def render(template)
      if Hash(template)[:plain] 
        @response['Content-Type'] = 'text/plain' 
      end        
      @request.env['simpler.template'] = template
    end

  end
end
