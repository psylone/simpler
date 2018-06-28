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

      update_params
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_content_type(type)
      @response['Content-Type'] = type
    end

    def status(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def headers
      @response
    end

    def params
      @request.params
    end

    def update_params
      resource_id = @request.path.split('/')[2]
      @request.params[:id] = resource_id if resource_id =~ /\A\d+\z/
    end

    def render(template = nil, plain: nil)
      if template
        @request.env['simpler.template'] = template
        set_content_type('text/html')
        set_template_path(template)
      elsif plain
        @request.env['simpler.plain'] = plain
        set_content_type('text/plain')
      end
    end

    def set_template_path(template_path)
      @response['X-Template'] = template_path
    end
  end
end
