require "logger"

module Simpler
  class AppLogger
    def initialize(app, **options)
      @logger = Logger.new(options[:logdev] || STDOUT)
      @app = app
    end
    def call(env)
      @status, @header, @body = @app.call(env)
      @request = Rack::Request.new(env)
      @logger.info(create_log)
      Rack::Response.new(@body, @status, @header).finish
    end

    private

    def create_log
      if @status == 404
        %Q(
        Request: #{@request.request_method} #{@request.fullpath}
        Handler: Nil
        Parameters: #{@request.params}
        Response: #{full_status}
      ).delete!("\n")
      else
        %Q(
        Request: #{@request.request_method} #{@request.fullpath}
        Handler: #{controller}##{action}
        Parameters: #{@request.params}
        Response: #{full_status} \[#{@header["Content-Type"]}\] #{view}
      ).delete!("\n")
      end
    end

    def controller
      @request.env["simpler.controller"].class.name
    end

    def action
      @request.env["simpler.action"]
    end

    def full_status
      "#{@status}" + " #{Rack::Utils::HTTP_STATUS_CODES[@status]}"
    end

    def view
      "#{@request.env["simpler.template"] || [controller, action].join("/")}.html.erb" unless @request.env["simpler.text_plain"]
    end
  end
end
