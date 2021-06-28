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
      @response.write(body) if @response.body.length == 0
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a?(Hash)
        @response['Content-Type'] = template.first[0].to_sym == :plain ? 'text/plain' : 'text/html'

        @response.body = ["#{template[template.first[0].to_sym]}\n"]
        @response.status = 201
        @response.finish
      else
        @request.env['simpler.template'] = template
      end
    end

    def set_headers(options=nil)
      if(options)
        options.each {|key, value| @response[key] = value}
      else
        set_default_headers
      end
    end

    def status(status)
      @response.status = status
    end

    def params
      @request.env['simpler.route_params']
    end

  end
end
