require_relative 'view'
require_relative 'controller/headers'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = Headers.new(@response)
    end

    def make_response(action)
      request.env['simpler.controller'] = self
      request.env['simpler.action'] = action

      set_default_headers
      send(action)
      set_default_render_options_if_not_specified
      write_response

      response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      response.write(body)
    end

    def render_body
      View.new(request.env).render(binding)
    end

    def params
      request.params.merge(request.env['simpler.route_params'])
    end

    def render(template = nil, **options)
      options[:template] = template if template
      request.env['simpler.render_options'] = options
    end

    def set_default_render_options_if_not_specified
      if request.env['simpler.render_options'].nil?
        request.env['simpler.render_options'] = {:template => nil}
      end
    end

    def status(status_code)
      response.status = status_code
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
