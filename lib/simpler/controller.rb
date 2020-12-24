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

    def set_headers(*type)
      @response['Content-Type'] = type ? "text/#{type}" || 'text/html'
    end

    def set_status(status)
      @response.status = status
    end

    def set_header(key, value)
      @response[key] = value
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
      if template.instance_of?(Hash)
         type = template.keys[0]
         set_headers(type)

         content = template.values[0]
         @request.env['simpler.template'] = content
       else
         @request.env['simpler.template'] = template
       end
    end
  end
end
