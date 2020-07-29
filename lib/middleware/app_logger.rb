require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(log_text(status, headers, env))
    [status, headers, body]
  end

  private

  def log_text(status, headers, env)
    "\n" +
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" +
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" +
    "Parameters: #{env['simpler.params']}\n" +
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}\n"
  end

end
