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

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      if @response.body.empty?
        body = render_body

        @response.write(body)
      end
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      if template.class == Hash
        body = View.new(@request.env).render(binding, render_text(template))
        @response.write(body)
        @response['Content-Type'] = 'text/plain'
      else
        @request.env['simpler.template'] = template
      end
    end

    def render_text(hash)
      text = ''
      hash.each do |k,v|
        if k == :plain || :inline
          text << v
        end
      end
      text
    end

    def status(code)
      @response.status = code
    end

  end
end
