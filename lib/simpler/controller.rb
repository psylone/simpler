require_relative 'view'
require 'byebug'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action,params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      
      set_params(params)

      set_headers
      set_status

      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(type = 'text/html')
      @response['Content-Type'] = type
    end

    def set_status(sym = :ok)
      @response.status = Rack::Utils::SYMBOL_TO_STATUS_CODE[sym]
    end

    def set_params(hash)
      hash.each {|key,value| @request.update_param(key, value) }
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      if @request.env['simpler.plain_text']
        @request.env['simpler.plain_text']
      else
        View.new(@request.env).render(binding)
      end
    end

    def params
      @request.params
    end

    def render(template)
      if template.is_a? String
        @request.env['simpler.template'] = template 
      elsif template.is_a? Hash
        @request.env['simpler.plain_text'] = template[:plain] if template[:plain]
      end
    end
  end
end
