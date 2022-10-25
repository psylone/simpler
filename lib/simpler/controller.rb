require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @status = 200
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
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template = nil, **options)
      options[:template] = template if template
      @request.env['simpler.render_options'] = options
    end

    def status(status_code)
      @response.status = status_code
    end

    # Common action(s)

    def page_not_found
      not_found_page_path = Simpler.root.join("public/404.html")
      file_content = File.read(not_found_page_path)

      status 404
      render html: file_content
    end
  end
end
