require_relative "view"

module Simpler
  class Controller
    HTTP_CODE_STATUSES = {
      "200" => "Ok",
      "201" => "Created",
      "400" => "Bad Request",
      "404" => "Not Found",
      "500" => "Internal Server Error",
    }.freeze

    attr_reader :name, :request, :response

    def initialize(env, logger)
      @logger = logger
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      build_params(env)
    end

    def make_response(action)
      @request.env["simpler.controller"] = self
      @request.env["simpler.action"] = action

      set_default_headers
      send(action)
      write_response

      log_info
      @response.finish
    end

    private

    def build_params(env)
      array = env["REQUEST_PATH"].split("/")
      @request.params[:id] = array[2].to_i if array[2].to_i && array[2].to_i != 0
      @logger.info("Parameters: #{@request.params.to_s} ")
    end

    def extract_name
      self.class.name.match("(?<name>.+)Controller")[:name].downcase
    end

    def set_default_headers
      @response["Content-Type"] = "text/html"
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

    def render(template)
      @request.env["simpler.template"] = template
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response
    end

    def log_info
      @logger.info("Response: #{@response.status}  #{HTTP_CODE_STATUSES[@response.status.to_s]} #{@response["Content-Type"]} #{@request.env["simpler.template_path"]}")
    end
  end
end
