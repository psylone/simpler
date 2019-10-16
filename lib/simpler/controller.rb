require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    RENDER_OPTIONS = %i[ status ].freeze

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
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template, options = {})
      if template.class == Hash
        @request.env['simpler.render_option_value'] = template.values[0]
        @request.env['simpler.render_option'] = template.keys[0]
        options = template.drop(1).to_h
      else
        @request.env['simpler.template'] = template
      end

      options.each do |option|
        if RENDER_OPTIONS.include?(option[0])
          send(option[0], option[1])
        end
      end
    end

    def status(number)
      @response.status = number
    end

  end
end
