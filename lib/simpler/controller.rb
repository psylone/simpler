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

      handler = {"handler" => "#{self.class.name}##{action}"}
      log_to_headers(handler)

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

    def log_to_headers(hash)
      hash.each_pair do |key, value|
        set_header(key.to_s, value)
      end
    end

    def set_content_type_json
      @response['Content-type'] = 'application/json'
    end

    def set_content_type_plain_text
      @response['Content-type'] = 'text/plain'
    end

    def set_header(key, value)
       @response[key] = value
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params[:id] = find_id_in_path
      log_to_headers(@request.params)

      p "------>>>> #{@request.params} <<<<<<<-------"
      @request.params
    end

    def find_id_in_path
      @request.path.split('/')[2]
    end

    def render(template)
      if template.is_a? Hash
        set_content_format(template)
      else
        @request.env['simpler.template'] = template
      end

      log_to_headers({'template_path' => template})
    end

    def set_content_format(template)
      case template.keys[0]
      when :plain
        set_content_type_plain_text
      when :json
        set_content_type_json
      else
        set_default_headers
      end
    end

    def status(status_code)
      @response.status = status_code
    end

  end
end
