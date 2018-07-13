require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:log] || STDOUT)
    @app    = Simpler.application
  end

  def call(env)
    status, headers, response = @app.call(env)
    logger(env, status, headers)
    [status, headers, response]
  end

  private

  def logger(env, status, headers)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    @logger.info("Handler: #{env['simpler.controller'].class}##{env['simpler.action']}")
    @logger.info("Parameters: #{env['action_params']}")
    @logger.info("Response: #{status} #{headers['Content-Type']} #{env['simpler.template']}")
  end

end

