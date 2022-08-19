require 'logger'

class Log

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)

    response = @app.call(env)
    
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}")
    @logger.info("Handler: #{env['simpler.handler']}")
    @logger.info("Parameters: #{env['simpler.params']}")
    @logger.info("Response: #{response[0]} [#{response[1]["Content-Type"]}] #{env['simpler.erb']}")
    response
  end

end
