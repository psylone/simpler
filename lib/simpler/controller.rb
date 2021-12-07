require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      params_id(env)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      headers
      send(action)
      write_response

      @response.finish
    end

    private

    def params_id(env)
      array = env['REQUEST_PATH'].split("/")
      @request.params[:id] = array[2].to_i if array[2].to_i && array[2].to_i != 0
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def headers (type = 'html')
      @response['Content-Type'] = "text/#{type}"
    end

    def status(status)
      @response.status = status
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
      headers(template.keys[0]) if template.class == Hash
      @request.env['simpler.template'] = template
    end

    def headers
      @response
    end
  end
end
