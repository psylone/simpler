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
      @request.env['simpler.params'] = @request.params.merge!(id: number)

      set_headers( { 'Content-Type' => 'text/html' } )
      set_status(201)
      send(action)
      write_response

      @response.finish
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

    def render(options)
     @request.env['simpler.template'] = options[:template]
     @request.env['simpler.plain'] = options[:plain]
   end

   def set_status(status)
     @response.status = status
   end

   def set_headers(headers)
     headers.each { |key, value| @response[key] = value }
   end

   def number
     @request.path_info.gsub(/[^\d]/, '')
   end

  end
end
