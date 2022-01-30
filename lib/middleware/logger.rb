require 'logger'

class AppLogger
  attr_reader :logger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info(request_info(env))
    @app.call(env, @logger)
  end

  private

  def request_info(env)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}"
  end
end
