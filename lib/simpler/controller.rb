require_relative 'view'

module Simpler
  class Controller
    FORMAT_CONTENT_TYPES = { plain: 'text/plain', html: 'text/html' }.freeze
    RENDER_FORMATS = [*FORMAT_CONTENT_TYPES.keys, :body].freeze

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

    def params
      request_params.merge(path_params)
    end

    private

    def set_default_headers
      @response['Content-Type'] ||= ['text/html']
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body
      @response.write("#{body}\n")
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def set_content_type_from_format(format)
      @response['Content-Type'] = FORMAT_CONTENT_TYPES[format]
    end

    # EG render plain: "404 Not Found", status: 404
    def render(options)
      # если не просто render :edit
      if options.is_a?(Hash)
        content_type, status = options.values_at(:content_type, :status)

        given_format = options.keys[0]
        set_content_type_from_format(given_format) if RENDER_FORMATS.include?(given_format)

        # если человек вдруг указал и формат и content-type, то приоритет будет у content-type
        set_header('Content-Type', content_type)
        @response.status = status if status
      end

      @request.env['simpler.template'] = options
    end

    def path_params
      @request.env['simpler.path_params']
    end

    def request_params
      @request.params
    end

    # теперь хедеры можно добавлять так: set_headers 'Content-Type', 'text/plain'
    def set_header(header_name, value)
      @response[header_name] = value unless value.nil?
    end

    # теперь статус можно устанавливать и не в рендере, а так: status 201
    def status(code)
      @response.status = code
    end
  end
end
