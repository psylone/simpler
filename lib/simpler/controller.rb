require_relative 'view'
require_relative 'headers'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @env = env
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.parameters'] = params


      # set_status
      send(action)
      set_headers
      write_response
      @response.finish
    end

    def params
      @params = {id: @env['PATH_INFO'].split('/').last}

      @env['QUERY_STRING'].split('&').each do |item|
        some_item = item.split('=')
        @params[:"#{some_item[0]}"] = some_item[1]
      end
    end

    def set_status(status)
      @response.status = status
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers
      @response['Content-Type'] = Headers.new(@env).header
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end



    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
