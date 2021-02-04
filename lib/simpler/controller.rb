require_relative 'view'

module Simpler
  class Controller

    SUCCESS_STATUS = 200
    REDIRECT_STATUS = 302

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.status'] = SUCCESS_STATUS

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
      if @request.env['simpler.redirect'].nil?
        body = render_body
        @response.write(body)
      end
    end

    def render_body
      if @request.env['simpler.template'].class == Hash && @request.env['simpler.template'].has_key?(:plain)
        return @request.env['simpler.template'][:plain]
      else
        # send corrent context controller to view render
        View.new(@request.env).render(binding)
      end
    end

    def params
      @request.params
    end

    def render(template = nil, **args)
      set_status(args)
      set_headers(args)
      render_template(template)
      render_plain(args)
    end

    def render_template(template)
      @request.env['simpler.template'] = template unless template.nil?
    end

    def render_plain(args)
      @request.env['simpler.template'] = { plain: args[:plain] } if args.has_key?(:plain)
    end

    def set_status(args)
      if args.has_key?(:status)
        @request.env['simpler.status'] = args[:status]
        @response.status = args[:status].to_i
      end
    end

    def set_headers(args)
      if args.has_key?(:headers) && args[:headers].class == Hash
        @request.env['simpler.headers'] = args[:headers]
        
        args[:headers].each do |key, value|
          @response[key] = value
        end
      end
    end

    def redirect_to(url, status = REDIRECT_STATUS)
      @request.env['simpler.status'] = status
      @request.env['simpler.redirect'] = url

      @response.redirect(url, status)
    end

  end
end
