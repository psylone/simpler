# frozen_string_literal: true

require_relative 'view'

module Simpler
  # Base controller class
  class Controller
    attr_reader :name, :request, :response
    attr_accessor :status, :headers

    DEFAULT_HEADERS = { 'Content-Type' => 'text/html' }.freeze
    DEFAULT_STATUS = 200

    def initialize(route, env)
      @route = route
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

      @route.path_params(env).each do |param, value|
        @request.update_param(param, value)
      end
      @status = DEFAULT_STATUS
      @headers = {}.merge!(DEFAULT_HEADERS)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = @request.params

      send(action)
      write_headers
      write_status
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_headers
      return unless @headers

      @headers.each do |key, value|
        @response[key] = value
      end
    end

    def write_status
      return unless @status

      @response.status = @status
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

    def render(*args)
      options = _normalize_args(*args)

      @request.env['simpler.template'] = options[:template]
      @request.env['simpler.plain'] = options[:plain]

      @headers.merge!(options[:headers]) if options[:headers]
      @status = options[:status] if options[:status]
    end

    def _normalize_args(template = nil, options = {})
      return template if template.is_a?(Hash)

      options[:template] = template
      options
    end
  end
end
