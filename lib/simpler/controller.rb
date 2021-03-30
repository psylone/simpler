require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, env)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      check_default_controller_action(env)

      check_header
      send(action)
      write_response

      check_for_default_template(env)

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def check_default_controller_action(env)
      if env["simpler.controller"].nil? || env["simpler.action"].nil?
        env["simpler.controller"] = ""
        env["simpler.action"] = ""
      else
        env["simpler.controller"] = env["simpler.controller"].name.capitalize! + "Controller#"
      end
    end

    def check_for_default_template(env)
      if env["simpler.template"].nil?
        env["simpler.template"] = ""
      else
        env["simpler.template"] += ".html.erb"
      end
    end

    def check_header
      check = @request.env['simpler.template']

      if check.is_a?(Hash)
        set_plain_headers if check.key?(:plain)
      else
        set_default_headers
      end
    end

    def set_plain_headers
      @response['Content-Type'] = 'text/plain'
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def status(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge(@request.env['simpler.route_params'])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
