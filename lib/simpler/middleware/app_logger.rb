require "logger"

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    status, headers, body = @app.call(env)
    @logger.info("Handler #{env['simpler.controller'].class}\##{env['simpler.action']}")
    @logger.info("Params: #{env['simpler.request_params']}")
    @logger.info("Response: #{status} #{headers['Content-Type']} #{env['simpler.template_path']}")

    [status, headers, body]
  end

end
