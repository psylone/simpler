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
      @request.env['simpler.controllername'] = self.class.name
      @request.env['simpler.action'] = action
      @request.env[:id] = get_id(@request.env) 

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def get_id(env)
      env['PATH_INFO'].match('\d+').to_s.to_i
    end

    def headers
      @response
    end

    def status(status)  
      @response.status = status
    end

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
