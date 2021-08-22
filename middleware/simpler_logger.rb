require 'logger'

class SimplerLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(log_message(response[0], response[1], env))
    response
  end

  private

  def log_message(status, headers, env)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" +
      "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n"+
      "Parameters: #{env['simpler.params']}\n"+
      "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template']}\n"
  end
end
