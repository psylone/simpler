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

    protected

    def params
      controller_name = extract_name
      reg_exp_string = "#{controller_name}/(?<id>\\d+)"
      @request.env['REQUEST_PATH'].match(reg_exp_string)[:id]
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
      body = render_body

      header_template = [extract_name, @request.env['simpler.action']].join('/')
      handler = [self.class.name, @request.env['simpler.action']].join('#')
      parameters = @request.params.to_s

      @response.add_header 'Template', "#{header_template}.html.erb"
      @response.add_header 'Handler', handler
      @response.add_header 'Parameters', parameters

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    # def params
    #   @request.params
    # end

    def render(template)
      @response.status = status(template)
      if plain_format?(template) 
        @request.env['simpler.text'] = template[:plain]
        @response['Content-Type'] = 'text/plain'
      else
        @request.env['simpler.template'] = template
      end
    end

    def plain_format?(template)
      template.class == Hash && (template.member? :plain)
    end

    def status(template)
      template.class == Hash && (template.member? :status) ? template[:status] : 200
    end

  end
end
