# frozen_string_literal: true

require_relative 'view'

module Simpler
  class Controller
    CONTENT_TYPES = { plain: 'text/plain',
                      html: 'text/html',
                      json: 'application/json',
                      xml: 'application/xml' }.freeze

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
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      @request.env['simpler.template'] ||= :html

      body = render_body

      @response.write(body)
    end

    def render_body
      View.render(@request.env, binding)
    end

    def render(data)
      render_data = if data.is_a? Hash
                      data
                    else
                      { html: data }
                    end

      content_type = render_data.keys.first

      @response['Content-Type'] = CONTENT_TYPES.fetch([content_type],
                                                      'text/plain')

      @request.env['simpler.template'] = content_type
      @request.env['simpler.template.body'] = render_data[content_type]
    end

    def status(code)
      @response.status = code
    end
  end
end
