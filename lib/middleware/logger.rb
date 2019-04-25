require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logfile] || STDOUT)
    @app = app
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
    @logger.info("Parameters: #{env['simpler.params']}")
    @logger.info("Response: #{status} #{headers['Content-Type']} #{env['simpler.render_view']}")
  end
end
