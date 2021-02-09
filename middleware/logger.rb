require 'logger'

module Simpler
  class AppLogger

    def initialize(app, **options)
      @logger = Logger.new(options[:logdev] || STDOUT )
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      status, headers, body = @app.call(env)

      controller = env["simpler.controller"]
      controller_name = controller.name.capitalize + "Controller#" if controller

      log = "\nRequest: #{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]}\n"
      log += "Handler: #{controller_name}#{env["simpler.action"]}\n"
      log += "Parameters: #{request.params}\n"
      log += "Response: #{status} [ #{headers["content-Type"]}] #{env['view']}\n"

      @logger.info(log)
      [status, headers, body]

    end
  end
end
