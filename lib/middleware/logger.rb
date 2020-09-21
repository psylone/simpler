require 'logger'

class AppLogger
  
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    # @logger.info(env)
    # @app.call(env)

    status, headers, response = @app.call(env)
    @logger.info(message(status, headers, env))    

    [status, headers, response]
  end

  private

  def message(status, headers, env)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Response: #{status} OK [#{headers['Content-Type']}] #{env['simpler.render']}\n" \
  end

end
