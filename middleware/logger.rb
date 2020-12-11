require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info message(env, status, headers)
    [status, headers, body]
  end

  def message(env, status, headers)
    "\nRequest: #{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]} \n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Responce: #{status} OK [#{headers['Content-Type']}] #{env['simpler.render']}\n"
  end

end
