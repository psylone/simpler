require_relative 'view'

module Simpler
  class Controller

    RESPONSE_HEADERS = { plain: 'text/plain', html: 'text/html' }.freeze

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
      set_headers(:html)
    end

    def headers_type(content_type)
      content_type_valid!(content_type)
      @response['Content-Type'] = RESPONSE_HEADERS[content_type]
      @request.env['simpler.content_type'] = content_type
    end

    def status_code(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge!(@request.env['simpler.params'])
    end

    def render(data)
      data = parse_data(data)
      set_headers(data[:type])

      @request.env['simpler.template'] = data[:body]
    end

    def parse_data(data)
      parsed_data = { body: nil, type: :html }

      if data.is_a?(Hash)
        parsed_data[:type] = data.keys[0]
        parsed_data[:body] = data[parsed_data[:type]]
      else
        parsed_data[:body] = data
      end

      parsed_data
    end

    def content_type_valid!(type)
      controller_action = "#{self.class.name}##{@request.env['simpler.action']}"

      raise "Неизвестный content type `#{type}` в #{controller_action}" unless content_type_valid?(type)
    end

    def content_type_valid?(type)
      RESPONSE_HEADERS.key?(type)
    end

  end
end
