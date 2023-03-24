require_relative 'view'
require 'active_support/all'
require 'json'

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

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end

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

    def format_response(hash)
      @request.env['simpler.body'] = if hash[:json]
                                       headers['Content-Type'] = 'text/json'
                                       hash[:json].to_json
                                     elsif hash[:xml]
                                       headers['Content-Type'] = 'text/xml'
                                       hash[:xml].to_xml
                                     elsif hash[:plain]
                                       headers['Content-Type'] = 'text/plain'
                                       hash[:plain].to_s
                                     elsif hash[:inline]
                                       hash[:inline]
                                     else
                                       'Unknown format'
                                     end
    end

    def render(template)
      format_response(template) if template.instance_of?(Hash)

      @request.env['simpler.template'] = template
    end
  end
end
