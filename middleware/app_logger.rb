require "logger"

class AppLogger

  def initialize(app)
    @logger = Logger.new('log/app.log')
    @app = app
  end

  def call(env)
    log_request(env)
    status, headers, body = @app.call(env)
    log_response(status, headers)
    [status, headers, body]
  end

  private 

  def log_response(status, headers)
    @logger.info("Handler: #{headers['handler']}")
    @logger.info("Parameters: #{headers["parameters"]}")
    @logger.info("Response: #{status} [#{headers["Content-Type"]}] #{headers['template']}")
  end

  def log_request(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
  end
end