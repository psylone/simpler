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
      @request.params.merge!(id: record)

      set_headers( { 'Content-Type' => 'text/html' } )
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(headers)
      headers.each { |key, value| @response[key] = value }
    end

    def set_status(number)
      @response.status = number
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      template = @request.env['simpler.template']

      return View.new(@request.env).render(binding) unless template.is_a?(Hash)

      "#{template[:plain]}\n" if template.key?(:plain)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def record
      @request.path_info.gsub(/[^\d]/, '')
    end
  end
end
