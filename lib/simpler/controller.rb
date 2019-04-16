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
      
      extract_resource_id
      set_default_headers

      send(action)
      write_response
      set_log_info
      
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def extract_resource_id
      @request.params[:id] = @request.env['PATH_INFO'].split("/").last.to_i if @request.env['PATH_INFO'].match(/.\/\d+\z/)
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body 

      @response.write(body)
    end

    def render_body
      if @request.env['simpler.rendering_options'] == :plain
        render_plain_text
      else
        View.new(@request.env).render(binding)
      end
    end

    def render_plain_text
      @request.env['simpler.rendering_value']
    end

    def params
      @request.params
    end

    def render(options)
      return @request.env['simpler.template'] = options unless options.is_a?(Hash)

      @request.env['simpler.rendering_options'] = options.keys.first
      @request.env['simpler.rendering_value'] = options.values.first
    end

    def set_response_status(status)
      @response.status = status.to_i
    end

    def set_custom_headers(headers)
      headers.each_pair { |key, value| @response[key.to_s] = value.to_s }
    end

    def set_log_info
      set_custom_headers(handler: "#{self.class.name}##{@request.env['simpler.action']}", 
                         parameters: "#{params}",
                         template: @request.env['simpler.template'] || [@name, @request.env['simpler.action']].join('/'))
    end
  end
end
