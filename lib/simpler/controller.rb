require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response


    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @request_type = env['REQUEST_METHOD']
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action


      set_params
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
      status_201
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def set_params
      @request.params.merge!(@request.env['simpler.params'])
    end

    def params
      @request.params
    end

    def render(template)
      if template.is_a?(Hash)
        @response['CONTENT_TYPE'] = 'text/plain'
        @request.env['simpler.plain_text'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

    def status_201
      if @request_type == "POST"
        @response.status == 201
      end
    end


  end
end
