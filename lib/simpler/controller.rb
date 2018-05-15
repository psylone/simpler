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

      check_params
      set_default_headers
      send(action) if action
      write_response

      @response.finish
    end

    def params
      arg = @request.env['PATH_INFO'].split('/').last.to_i
      {id: arg} if @request.env['simpler.action'] == 'show'
    end

    private

    def change_header
      @response['Content-Type'] = 'text/plain'
    end

    def check_status
      @response.status = 201 if @request.env['REQUEST_METHOD'] == 'POST'
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      case @response['Content-Type']
        when 'text/plain'
          body = @request.env['simpler.template_plain']
        when 'text/html'
          body = render_body
      end

      check_status
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template[:plain]
        change_header
        @request.env['simpler.template_plain'] = template[:plain]
      else
        @request.env['simpler.template'] = template
      end
    end

    def check_params
      if @request.env['QUERY_STRING']
        params = {}
        args = @request.env['QUERY_STRING'].split('&')
        args.each do |arg|
          arg = arg.split('=')
          params[arg[0]] = arg[1]
        end
        @request.env['simpler.parameters'] = params
      end
    end
  end
end
