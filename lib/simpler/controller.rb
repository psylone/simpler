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
      @request.env['simpler.params'].each { |key, value| @request.update_param(key.to_sym, value) }

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_status(code)
      @response.status = code
    end

    def set_default_headers
      set_header('Content-Type', 'text/html')
    end

    def set_header(key, value)
      @response[key] = value
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env, @render_type).render(binding)
    end

    def params
      @request.env['simpler.route.params'].merge!@request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
      
      if template.is_a?(String)
        @render_type = 'html'
        render_html(template)
      elsif template.keys.first
        @render_type = 'plain'
        render_plain(template)
      end
    end

    def render_plain(template)
      set_header('Content-Type', 'text/html')
      @request.env['simpler.template'] = template[:plain]
    end

    def render_html(template)
      @request.env['simpler.template'] = template
    end

  end
end
