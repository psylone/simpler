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

      send(action)

      if @request.env['simpler.format'] && @request.env['simpler.output']
        @response['Content-Type'] = header_for(@request.env['simpler.format'])
        @response.write(@request.env['simpler.output'])
      else
        set_default_headers
        write_response
      end

      @response.finish
    end

    def status(status)
      @response.status = status
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

    def render(argument)
      case argument
      when Hash
        format = argument.keys.first
        output = argument.values.first
        @request.env['simpler.format'] = format
        @request.env['simpler.output'] = output
      else
        template = argument
        @request.env['simpler.template'] = template
      end
    end

    def header_for(format)
      case format
      when :plain
        'text/plain'
      when :html
        'text/html'
      end
    end

  end
end
