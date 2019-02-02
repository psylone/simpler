require_relative 'view'

module Simpler
  class Controller
    RENDER_FORMATS = %i[body plain html].freeze
    FORMAT_CONTENT_TYPES = { plain: 'text/plain', html: 'text/html' }.freeze

    attr_reader :name, :request, :response
    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      set_rendered_content_type
      send(action)
      write_response

      @response.finish
    end

    def params
      request_params
      request_params.merge(path_params) if path_params && request_params
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def set_rendered_content_type(format = default_format)
      @response['Content-Type'] = FORMAT_CONTENT_TYPES[format]
    end

    # EG render plain: "404 Not Found", status: 404
    def render(options)
      # если не просто render :edit
      if options.is_a?(Hash)
        content_type, status = options.values_at(:content_type, :status)

        given_format = options.keys[0]
        render_format = RENDER_FORMATS.include?(given_format) ? given_format : default_format
        set_rendered_content_type(render_format)
        # если человек вдруг указал и формат и content-type, то приоритет будет у content-type
        @response['Content-Type'] = content_type if content_type
        @response.status = status if status
      end

      @request.env['simpler.template'] = options
    end

    def default_format
      :html
    end

    def path_params
      @request.env['simpler.path_params']
    end

    def request_params
      @request.params
    end

    # теперь хедеры можно добавлять так: set_headers 'Content-Type', 'text/plain'
    def set_headers(header_name, value)
      @response[header_name] = value
    end

    # теперь статус можно устанавливать и не в рендере, а так: status 201
    def status(code)
      @response.status = code
    end
  end
end
