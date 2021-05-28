require_relative 'view'

module Simpler
  class Controller
    RENDER_TYPE = { html: 'text/html', plain: 'text/plain', json: 'text/json' }.freeze
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
      set_headers_type(:html)
    end

    def set_status(code)
      @response.status = code
    end

    def set_headers_type(type)
      render_type_valid!(type)
      @response['Content-Type'] = RENDER_TYPE[type]
      @request.env['simpler.content_type'] = type
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
      data = parse_render_data(data)
      set_headers_type(data[:type])

      @request.env['simpler.template'] = data[:body]
    end

    def parse_render_data(data)
      parsed_data = { body: nil, type: :html }

      if data.is_a?(Hash)
        parsed_data[:type] = data.keys[0]
        parsed_data[:body] = data[parsed_data[:type]]
      else
        parsed_data[:body] = data
      end

      parsed_data
    end

    def render_type_valid!(type)
      controller_action = "#{self.class.name}##{@request.env['simpler.action']}"

      raise "Unknown content type `#{type}` in #{controller_action}" unless render_type_valid?(type)
    end

    def render_type_valid?(type)
      RENDER_TYPE.has_key?(type)
    end
  end
end
