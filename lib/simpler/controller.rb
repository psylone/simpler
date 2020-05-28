require_relative 'view'

module Simpler
  class Controller

    RENDER_OPTIONS = {plain: 'text/plain', html: 'text/html'}

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
      if (match_data = env['PATH_INFO'].match(/\/(?<path>\w+)\/(?<id>\d+)/))
        params[:id] = match_data[:id]
      end
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.template'] = action

      set_default_headers
      send(action)
      write_response(action) if @response.body.empty?

      @response.finish
    end

    def render(template)
      if template.is_a?(Hash)
        if RENDER_OPTIONS.key?(template.first[0])
          @response['Content-Type'] = RENDER_OPTIONS[template.first[0]]
          @response.write(template.first[1])
        else
          raise 'wrong render option'
        end
      else
        @request.env['simpler.template'] = template.to_s
      end
    end

    def status(number)
      @response.status = number
    end


    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response(action)
      body = render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end


  end
end
