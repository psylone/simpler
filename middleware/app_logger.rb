require "logger"

class AppLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logfile] || STDOUT)
  end

  def call(env)
    log_request(env)
    @status, @headers, @body = @app.call(env)
    log_response(env)
    [@status, @headers, @body]
  end

  def log_request(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']} #{env['QUERY_STRING']}")
  end

  def log_response(env)
    @logger.info("Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}")
    @logger.info("Parameters: #{env['simpler.route_params']}")
    @logger.info("Response: #{@status} #{@headers['Content-Type']} #{env['simpler.template']}")
  end
end
