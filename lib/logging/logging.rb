require_relative 'custom_logger/custom_logger'

class Logging
  def initialize(app)
    @app = app
    @logger = CustomLogger::CustomLogger.new
  end

  def call(env)
    env['simpler.logger'] = @logger

    status, headers, body = @app.call(env)

    [status, headers, body]
  end
end
