# frozen_string_literal: true

require 'pry'

require_relative 'view'

module Simpler
  class Controller
    CONTENT_TYPE = {
      plain: 'text/plain',
      json: 'application/json',
      default: 'text/html'
    }.freeze

    attr_reader :name, :request, :response, :params

    def initialize(env, params = {})
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @params = params
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.format'] = :default
      @request.env['simpler.template'] = "#{name}/#{action}"

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def not_found
      render plain: 'Oops! Something wrong'
      status 404
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body
      set_appropriate_header

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      return unless template.is_a? Hash

      @request.env['simpler.format'] = template.keys.first
      @request.env['simpler.template'] = template.values.first
    end

    def status(response_code)
      return unless Rack::Utils::HTTP_STATUS_CODES.keys.include? response_code

      @response.status = response_code
    end

    def set_appropriate_header
      @response['Content-Type'] = CONTENT_TYPE[@request.env['simpler.format']]
    end
  end
end
