# frozen_string_literal: true

require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, logger)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @logger = logger

      @logger.info("Handler: #{self.class.name}\##{action}")
      @logger.info("Parameters: #{prepare_params}")
      set_default_headers
      send(action)
      write_response

      @logger.info("Response: #{@response.status} [#{@response.content_type}] #{name}.html.erb")
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
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      pattern = '((?<path>.*)/(?<id>\d*))'
      @request.path.match(pattern)
    end

    def prepare_params
      params.named_captures
    end

    def status(status_code)
      @response.status = status_code
    end

    def headers
      @response
    end

    def render(template)
      @request.env['simpler.template'] = template
    end
  end
end
