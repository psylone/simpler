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

      set_default_headers
      send(action)
      write_response
 
      @response.finish
    end

    def params
      @params ||= @request.params.merge(@request.env['simpler.route_params'])
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def headers
      @response
    end    

    def status(code)    
      @response.status = code.to_s 
    end

    def write_response
      @response.write(render_body) if @response.body.empty?     
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template[:plain]
        plain(template[:plain])
      else
        @request.env['simpler.template'] = template
      end  
    end

   def plain(text) 
    @response.write(text)
    @response['Content-Type'] = 'text/plain'
   end

  end
end
