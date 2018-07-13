require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name     = extract_name
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action']     = action

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
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def plain(text)
      @response.write(text)
      @response['Content-Type'] = 'text/plain'
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response.headers
    end

    def action_params
      @request.env['action_params']
    end

    def render(template)
      puts 'dddddd'
      return plain(template[:plain]) unless template[:plain].nil?
      puts @request.env['simpler.template']
      @request.env['simpler.template'] = template
    end

  end
end
