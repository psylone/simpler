require 'logger'

class AppLogger

  def initialize(app, **option)
    @logger = Logger.new(option[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info(log_request(env))
    @app.call(env, @logger)
  end

  def log_request(env)
    "Request: " + env['REQUEST_METHOD'] + " " + env['PATH_INFO'] + "?" + env['QUERY_STRING']
  end

end