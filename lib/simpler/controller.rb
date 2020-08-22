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
      add_header('Simpler-Controller' => self.class.name)
      add_header('Params' => params.to_s)
      add_header('Rendered-Template' => @view.rendered_template.to_s)

      @response.finish
    end

    def add_header(header)
      @response[header.keys.first] = header.values.first
    end

    def set_status(status)
      @response.status = status
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/plain'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      @view = View.new(@request.env)
      @view.render(binding)
    end

    def params
      last_slash_index = @request.env['REQUEST_PATH'].rindex(/\//) + 1
      length = @request.env['REQUEST_PATH'].length
      { @request.env['params'] => @request.env['REQUEST_PATH'][last_slash_index, length] }
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end