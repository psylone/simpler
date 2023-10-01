require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :status

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

    def set_headers
      @response.headers
    end

    def write_response
      body = render_body
      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = set_headers['Content-Type']

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    # def render(template, status = {})
    #   case template
    #   when String
    #     set_headers['Content-Type'] = 'text/html'
    #   when Hash
    #     if template.has_key?(:plain)
    #       set_headers['Content-Type'] = 'text/plain'
    #     end
    #   end

    def render(template, status = {}) 
      @request.env['simpler.template'] = template 
      if status.is_a?(Integer) && status >= 100
        status = status[:status] || template[:status] 
        @response.status = status 
      end 
    end

  end
end
