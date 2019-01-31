require_relative 'view'

module Simpler
  class Controller
    RENDER_FORMATS = %i[body plain html].freeze

    attr_reader :name, :request, :response, :format

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
      @request.params
    end

    private

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

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

    def set_rendered_content_type(format)
      if format && !@response['Content-Type']
        case format
          when :plain then @response['Content-Type'] = "text/plain"
        else
          # если формат не указан и контент тайп не указан - по дефолту устанавливаем, или есть формат :html
          @response['Content-Type'] = "text/html"
        end
      end
    end

    # EG render plain: "404 Not Found", status: 404
    def render(options)
      # если не просто render :edit
      if options.is_a?(Hash)

        content_type, status = options.values_at(:content_type, :status)
        @response['Content-Type'] = content_type if content_type
        @response.status = status if status
        format = RENDER_FORMATS.find { |f| options.keys[0] == f }
        @format = format.nil? ? :html : format
        set_rendered_content_type(@format)
      end

      @request.env['simpler.template'] = options
    end
  end
end
